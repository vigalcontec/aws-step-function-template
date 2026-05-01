# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-01

### Added

- **Step Functions State Machine** - Base template with Success state
- **Terraform Infrastructure** - Full IaC with modular configuration
- **GitHub Actions CI/CD** - OIDC authentication, multi-environment support
- **SSM Parameter Exports** - State machine ARN, name, and role ARN
- **SSM Parameter Imports** - Examples for datalake and Lambda integration
- **EventBridge Trigger** - Optional S3 event trigger (commented)
- **Lambda Integration** - Optional Lambda invocation support (commented)
- **X-Ray Tracing** - End-to-end observability
- **CloudWatch Logs** - Execution logging with configurable retention

### Configuration

| File | Purpose |
|------|---------|
| `config.tf` | Project settings, S3 trigger, Lambda functions |
| `main.tf` | State machine definition |
| `ssm_imports.tf` | Import parameters from other projects |
| `ssm_exports.tf` | Export parameters for integration |
| `eventbridge.tf` | S3 trigger configuration |
| `iam.tf` | IAM roles and policies |

### CI/CD Features

- **Manual Trigger** - `workflow_dispatch` for deploy/destroy
- **Environment Detection** - Branch-based (main→prod, release/*→qa, *→dev)
- **Terraform Validate** - Format and validation checks on PR
- **Template Mode** - Triggers commented out by default
