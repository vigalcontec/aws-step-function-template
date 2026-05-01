# AWS Step Function Template

[![AWS Step Functions](https://img.shields.io/badge/AWS-Step%20Functions-FF9900?logo=amazon-aws)](https://aws.amazon.com/step-functions/)
[![Terraform](https://img.shields.io/badge/Terraform-1.10%2B-7B42BC?logo=terraform)](https://www.terraform.io/)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=github-actions)](https://github.com/features/actions)

Production-ready AWS Step Functions template with Terraform, GitHub Actions CI/CD, and SSM Parameter Store integration.

---

## Features

- **Step Functions** - State machine with logging and X-Ray tracing
- **Terraform IaC** - Full infrastructure as code
- **GitHub Actions** - CI/CD with OIDC authentication
- **Multi-environment** - dev, qa, prod support
- **SSM Integration** - Import/export parameters for service integration
- **S3 Trigger** - Optional EventBridge trigger for S3 events
- **Lambda Integration** - Optional Lambda function invocation

---

## Repository Structure

```
aws-step-function-template/
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD pipeline
├── terraform/
│   ├── config.tf                   # PROJECT CONFIG (edit this!)
│   ├── main.tf                     # Step Function state machine
│   ├── iam.tf                      # IAM roles and policies
│   ├── eventbridge.tf              # S3 trigger (optional)
│   ├── ssm_imports.tf              # Import SSM parameters
│   ├── ssm_exports.tf              # Export SSM parameters
│   ├── variables.tf                # Runtime variables
│   ├── outputs.tf                  # Output values
│   ├── providers.tf                # AWS provider
│   └── backend.tf                  # S3 backend
├── CHANGELOG.md
└── README.md
```

---

## Prerequisites

- **Terraform 1.10+**
- **AWS Bootstrap** - `aws-bootstrap-tfstate-oidc` deployed (provides state bucket and OIDC role)

---

## Quick Start

### Step 1: Create Repository from Template

Click **"Use this template"** on GitHub to create a new repository.

### Step 2: Configure Project

Edit `terraform/config.tf`:

```hcl
locals {
  project_name = "my-step-function"  # Your Step Function name
  company_name = "mycompany"         # Your company name

  # Optional: S3 trigger configuration
  s3_trigger = {
    enabled = false             # Set to true to enable
    prefix  = "uploads/"        # S3 prefix to monitor
    suffix  = ".json"           # File extension filter
  }

  # Optional: Lambda functions to invoke
  lambda_functions = [
    # "my-lambda-function",
  ]
}
```

### Step 3: Configure GitHub Secrets

Add to your repository (`Settings > Secrets and variables > Actions`):

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_ARN_DEV` | GitHub Actions IAM role ARN for dev |
| `AWS_ROLE_ARN_QA` | GitHub Actions IAM role ARN for qa |
| `AWS_ROLE_ARN_PROD` | GitHub Actions IAM role ARN for prod |

### Step 4: Enable CI/CD Workflows

Edit `.github/workflows/deploy.yml` and uncomment the triggers:

```yaml
on:
  workflow_dispatch:
    # ... (keep as is)
  push:                                    # ← Uncomment
    branches: [main, develop, "feature/*", "release/*"]
    paths:
      - 'terraform/**'
      - '.github/workflows/deploy.yml'
  pull_request:                            # ← Uncomment
    branches: [main, develop]
    paths:
      - 'terraform/**'
```

### Step 5: Deploy

Push to trigger CI/CD or use manual workflow dispatch.

---

## Customizing the State Machine

Edit `terraform/main.tf` to define your workflow:

```hcl
definition = jsonencode({
  Comment = "My Custom Workflow"
  StartAt = "Step1"
  States = {
    Step1 = {
      Type = "Task"
      Resource = "arn:aws:lambda:..."
      Next = "Step2"
    }
    Step2 = {
      Type = "Succeed"
    }
  }
})
```

### Common State Types

| Type | Description |
|------|-------------|
| `Task` | Invoke Lambda, API, or AWS service |
| `Pass` | Transform data |
| `Choice` | Conditional branching |
| `Parallel` | Run branches in parallel |
| `Map` | Iterate over array |
| `Wait` | Delay execution |
| `Succeed` | End successfully |
| `Fail` | End with error |

---

## SSM Integration

### Importing Parameters

Edit `terraform/ssm_imports.tf` to read parameters from other projects:

```hcl
data "aws_ssm_parameter" "lambda_arn" {
  name = "/${var.environment}/lambda/my-function/function_arn"
}
```

### Exported Parameters

This template exports to SSM:

| Parameter | Description |
|-----------|-------------|
| `/{env}/stepfunction/{name}/state_machine_arn` | State machine ARN |
| `/{env}/stepfunction/{name}/state_machine_name` | State machine name |
| `/{env}/stepfunction/{name}/role_arn` | Execution role ARN |

---

## Deployment

### Automatic (Push)

| Branch | Environment |
|--------|-------------|
| `main` | prod |
| `release/*` | qa |
| `develop`, `feature/*` | dev |

### Manual

1. Go to **Actions** → **Deploy Step Function**
2. Click **Run workflow**
3. Select environment and action (`deploy` or `destroy`)

---

## Infrastructure Created

| Resource | Description |
|----------|-------------|
| Step Function | State machine with logging |
| IAM Role | Execution role with CloudWatch/X-Ray permissions |
| CloudWatch Logs | Execution logs with configurable retention |
| SSM Parameters | Exported ARNs for integration |

---

## Testing

Execute the Step Function manually:

```bash
aws stepfunctions start-execution \
  --state-machine-arn arn:aws:states:eu-west-1:123456789012:stateMachine:my-step-function-dev \
  --input '{"key": "value"}'
```

Check execution status:

```bash
aws stepfunctions list-executions \
  --state-machine-arn arn:aws:states:eu-west-1:123456789012:stateMachine:my-step-function-dev
```

---

## Adding S3 Trigger

1. Enable in `config.tf`:
   ```hcl
   s3_trigger = {
     enabled = true
     prefix  = "uploads/"
     suffix  = ".json"
   }
   ```

2. Uncomment resources in:
   - `terraform/ssm_imports.tf` - Datalake bucket data
   - `terraform/eventbridge.tf` - EventBridge rule and target
   - `terraform/iam.tf` - EventBridge IAM role

---

## Adding Lambda Integration

1. Add Lambda names in `config.tf`:
   ```hcl
   lambda_functions = [
     "my-lambda-function",
   ]
   ```

2. Uncomment in `terraform/ssm_imports.tf`:
   ```hcl
   data "aws_ssm_parameter" "lambda_arns" { ... }
   locals { lambda_arns = { ... } }
   ```

3. Uncomment in `terraform/iam.tf`:
   ```hcl
   resource "aws_iam_role_policy" "step_function_lambda" { ... }
   ```

4. Use in `terraform/main.tf`:
   ```hcl
   Resource = local.lambda_arns["my-lambda-function"]
   