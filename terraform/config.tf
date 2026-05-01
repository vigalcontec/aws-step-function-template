# =============================================================================
# Configuration - Update these values for your project
# =============================================================================

locals {
  # ─────────────────────────────────────────────────────────────────────────────
  # Project Configuration (UPDATE THESE)
  # ─────────────────────────────────────────────────────────────────────────────
  project_name = "my-step-function" # Step Function name (without env suffix)
  company_name = "mycompany"        # Company name for resource naming

  # ─────────────────────────────────────────────────────────────────────────────
  # S3 Trigger Configuration (Optional - set enabled = false to disable)
  # ─────────────────────────────────────────────────────────────────────────────
  s3_trigger = {
    enabled = true              # Set to false to disable S3 trigger
    prefix  = "uploads/"        # S3 prefix to monitor
    suffix  = ""                # File suffix filter (e.g., ".json", ".csv")
  }

  # ─────────────────────────────────────────────────────────────────────────────
  # Lambda Functions to invoke (read from SSM - Optional)
  # Add Lambda function names here if your Step Function invokes Lambdas
  # Each Lambda must be deployed separately and export its ARN to SSM at:
  #   /{env}/lambda/{function_name}/function_arn
  # ─────────────────────────────────────────────────────────────────────────────
  lambda_functions = [
    # "my-lambda-function",
    # "another-lambda",
  ]

  # ─────────────────────────────────────────────────────────────────────────────
  # AWS Configuration
  # ─────────────────────────────────────────────────────────────────────────────
  aws_region         = "eu-west-1"
  log_retention_days = 30

  # ─────────────────────────────────────────────────────────────────────────────
  # Computed Values (DO NOT MODIFY)
  # ─────────────────────────────────────────────────────────────────────────────
  account_id   = data.aws_caller_identity.current.account_id
  full_name    = "${local.project_name}-${var.environment}"
  state_bucket = "tfstate-${local.company_name}-${var.environment}-${local.account_id}"

  # Common tags applied to all resources
  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
