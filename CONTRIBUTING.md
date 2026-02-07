# Contributing to AWS VPC Infrastructure

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

- Use GitHub Issues to report bugs or suggest features
- Search existing issues before creating a new one
- Provide detailed information:
  - Terraform version
  - AWS Provider version
  - Steps to reproduce
  - Expected vs actual behavior

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Standards

- Follow Terraform best practices
- Use consistent formatting (`terraform fmt`)
- Validate before committing (`terraform validate`)
- Add comments for complex logic
- Update documentation

### Testing

- Test in non-production environment first
- Verify both production and non-production configurations
- Check cost implications
- Ensure backward compatibility

### Documentation

- Update README.md for new features
- Add examples for new functionality
- Update TFVARS-GUIDE.md for new variables
- Keep VERSION.md current

## Development Setup

```bash
# Clone repository
git clone https://github.com/yourusername/aws-vpc-infrastructure.git
cd aws-vpc-infrastructure

# Install Terraform (>= 1.9.0)
# Install AWS CLI

# Test configuration
cd vpc-ha
terraform init
terraform validate
terraform fmt -check
```

## Code Review Process

1. All PRs require review
2. CI/CD checks must pass
3. Documentation must be updated
4. No breaking changes without major version bump

## Questions?

Open an issue or reach out to maintainers.

Thank you for contributing! 🎉
