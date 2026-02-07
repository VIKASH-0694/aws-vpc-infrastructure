# PowerShell script to create new client from template
# Usage: .\scripts\new-client.ps1 -ClientName "client-name" -ClientNumber 1

param(
    [Parameter(Mandatory=$true)]
    [string]$ClientName,
    
    [Parameter(Mandatory=$true)]
    [int]$ClientNumber
)

$ClientDir = "clients\$ClientName"

if (Test-Path $ClientDir) {
    Write-Error "Client directory already exists: $ClientDir"
    exit 1
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Creating new client: $ClientName" -ForegroundColor Cyan
Write-Host "Client number: $ClientNumber" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Copy template
Copy-Item -Path "clients\client-template" -Destination $ClientDir -Recurse

# Calculate CIDR blocks
$ProdCIDR = "10.$($ClientNumber * 10).0.0/16"
$NonProdCIDR = "10.$($ClientNumber * 10 + 1).0.0/16"

Write-Host ""
Write-Host "Assigned CIDR blocks:" -ForegroundColor Green
Write-Host "  Production: $ProdCIDR"
Write-Host "  Non-Prod:   $NonProdCIDR"

# Update production tfvars
$ProdTfvars = "$ClientDir\prod\terraform.tfvars"
Copy-Item "$ClientDir\prod\terraform.tfvars.example" $ProdTfvars
(Get-Content $ProdTfvars) -replace 'project_name         = "myapp"', "project_name         = `"$ClientName`"" | Set-Content $ProdTfvars
(Get-Content $ProdTfvars) -replace 'vpc_cidr             = "10.0.0.0/16"', "vpc_cidr             = `"$ProdCIDR`"" | Set-Content $ProdTfvars
(Get-Content $ProdTfvars) -replace 'web_subnet_cidrs = \["10.0.1.0/24", "10.0.2.0/24"\]', "web_subnet_cidrs = [`"10.$($ClientNumber * 10).1.0/24`", `"10.$($ClientNumber * 10).2.0/24`"]" | Set-Content $ProdTfvars
(Get-Content $ProdTfvars) -replace 'app_subnet_cidrs = \["10.0.11.0/24", "10.0.12.0/24"\]', "app_subnet_cidrs = [`"10.$($ClientNumber * 10).11.0/24`", `"10.$($ClientNumber * 10).12.0/24`"]" | Set-Content $ProdTfvars
(Get-Content $ProdTfvars) -replace 'db_subnet_cidrs  = \["10.0.21.0/24", "10.0.22.0/24"\]', "db_subnet_cidrs  = [`"10.$($ClientNumber * 10).21.0/24`", `"10.$($ClientNumber * 10).22.0/24`"]" | Set-Content $ProdTfvars

# Update non-production tfvars
$NonProdTfvars = "$ClientDir\nonprod\terraform.tfvars"
Copy-Item "$ClientDir\nonprod\terraform.tfvars.example" $NonProdTfvars
(Get-Content $NonProdTfvars) -replace 'project_name         = "myapp"', "project_name         = `"$ClientName`"" | Set-Content $NonProdTfvars
(Get-Content $NonProdTfvars) -replace 'vpc_cidr             = "10.1.0.0/16"', "vpc_cidr             = `"$NonProdCIDR`"" | Set-Content $NonProdTfvars
(Get-Content $NonProdTfvars) -replace 'web_subnet_cidrs = \["10.1.1.0/24", "10.1.2.0/24"\]', "web_subnet_cidrs = [`"10.$($ClientNumber * 10 + 1).1.0/24`", `"10.$($ClientNumber * 10 + 1).2.0/24`"]" | Set-Content $NonProdTfvars
(Get-Content $NonProdTfvars) -replace 'app_subnet_cidrs = \["10.1.11.0/24", "10.1.12.0/24"\]', "app_subnet_cidrs = [`"10.$($ClientNumber * 10 + 1).11.0/24`", `"10.$($ClientNumber * 10 + 1).12.0/24`"]" | Set-Content $NonProdTfvars
(Get-Content $NonProdTfvars) -replace 'db_subnet_cidrs  = \["10.1.21.0/24", "10.1.22.0/24"\]', "db_subnet_cidrs  = [`"10.$($ClientNumber * 10 + 1).21.0/24`", `"10.$($ClientNumber * 10 + 1).22.0/24`"]" | Set-Content $NonProdTfvars

Write-Host ""
Write-Host "✓ Client created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review and edit: $ClientDir\prod\terraform.tfvars"
Write-Host "2. Review and edit: $ClientDir\nonprod\terraform.tfvars"
Write-Host "3. Deploy non-prod: cd $ClientDir\nonprod; terraform init; terraform apply"
Write-Host "4. Deploy prod: cd $ClientDir\prod; terraform init; terraform apply"
Write-Host ""
