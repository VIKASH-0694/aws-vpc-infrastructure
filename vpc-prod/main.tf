# VPC with HA configuration
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
    }
  )
}

# Web Tier - Public Subnets in multiple AZs
resource "aws_subnet" "web_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_subnet_cidrs[0]
  availability_zone       = local.availability_zones[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-web-subnet-az1"
      Tier = "web"
    }
  )
}

resource "aws_subnet" "web_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_subnet_cidrs[1]
  availability_zone       = local.availability_zones[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-web-subnet-az2"
      Tier = "web"
    }
  )
}

# Application Tier - Private Subnets in multiple AZs
resource "aws_subnet" "app_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[0]
  availability_zone = local.availability_zones[0]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-app-subnet-az1"
      Tier = "application"
    }
  )
}

resource "aws_subnet" "app_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[1]
  availability_zone = local.availability_zones[1]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-app-subnet-az2"
      Tier = "application"
    }
  )
}

# Database Tier - Private Subnets in multiple AZs
resource "aws_subnet" "db_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[0]
  availability_zone = local.availability_zones[0]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-db-subnet-az1"
      Tier = "database"
    }
  )
}

resource "aws_subnet" "db_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[1]
  availability_zone = local.availability_zones[1]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-db-subnet-az2"
      Tier = "database"
    }
  )
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_az1" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name     = "${var.project_name}-${var.environment}-nat-eip-az1"
      CostNote = "NAT Gateway EIP - $0.005/hour when not attached"
    }
  )
}

resource "aws_eip" "nat_az2" {
  count = var.enable_nat_gateway && !var.single_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name     = "${var.project_name}-${var.environment}-nat-eip-az2"
      CostNote = "NAT Gateway EIP - $0.005/hour when not attached"
    }
  )
}

# NAT Gateways in each AZ for HA
resource "aws_nat_gateway" "az1" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat_az1[0].id
  subnet_id     = aws_subnet.web_az1.id

  tags = merge(
    local.common_tags,
    {
      Name     = "${var.project_name}-${var.environment}-nat-gateway-az1"
      CostNote = "NAT Gateway - ~$32/month + $0.045/GB processed"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "az2" {
  count = var.enable_nat_gateway && !var.single_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat_az2[0].id
  subnet_id     = aws_subnet.web_az2.id

  tags = merge(
    local.common_tags,
    {
      Name     = "${var.project_name}-${var.environment}-nat-gateway-az2"
      CostNote = "NAT Gateway - ~$32/month + $0.045/GB processed"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# Route Table for Web Tier (Public)
resource "aws_route_table" "web" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-web-rt"
      Tier = "web"
    }
  )
}

# Route Tables for Application Tier (one per AZ for HA)
resource "aws_route_table" "app_az1" {
  count = var.enable_nat_gateway ? 1 : 0

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az1[0].id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-app-rt-az1"
      Tier = "application"
    }
  )
}

resource "aws_route_table" "app_az2" {
  count = var.enable_nat_gateway && !var.single_nat_gateway ? 1 : 0

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az2[0].id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-app-rt-az2"
      Tier = "application"
    }
  )
}

# Route Tables for Database Tier (one per AZ for HA)
resource "aws_route_table" "db_az1" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-db-rt-az1"
      Tier = "database"
    }
  )
}

resource "aws_route_table" "db_az2" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-db-rt-az2"
      Tier = "database"
    }
  )
}

# Route Table Associations - Web Tier
resource "aws_route_table_association" "web_az1" {
  subnet_id      = aws_subnet.web_az1.id
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "web_az2" {
  subnet_id      = aws_subnet.web_az2.id
  route_table_id = aws_route_table.web.id
}

# Route Table Associations - Application Tier
resource "aws_route_table_association" "app_az1" {
  subnet_id      = aws_subnet.app_az1.id
  route_table_id = var.enable_nat_gateway ? aws_route_table.app_az1[0].id : aws_route_table.db_az1.id
}

resource "aws_route_table_association" "app_az2" {
  subnet_id      = aws_subnet.app_az2.id
  route_table_id = var.enable_nat_gateway && !var.single_nat_gateway ? aws_route_table.app_az2[0].id : (var.enable_nat_gateway ? aws_route_table.app_az1[0].id : aws_route_table.db_az2.id)
}

# Route Table Associations - Database Tier
resource "aws_route_table_association" "db_az1" {
  subnet_id      = aws_subnet.db_az1.id
  route_table_id = aws_route_table.db_az1.id
}

resource "aws_route_table_association" "db_az2" {
  subnet_id      = aws_subnet.db_az2.id
  route_table_id = aws_route_table.db_az2.id
}

# Data source for available AZs
data "aws_availability_zones" "available" {
  state = "available"
}
