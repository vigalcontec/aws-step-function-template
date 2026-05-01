# =============================================================================
# SSM Parameter Imports
# =============================================================================
# Read configuration from SSM Parameter Store.
# These parameters are created by other Terraform projects (e.g., aws-datalake-layers).
# Uncomment and modify based on your project needs.

# ─────────────────────────────────────────────────────────────────────────────
# Example: Datalake Configuration
# ─────────────────────────────────────────────────────────────────────────────
# Uncomment these if your Step Function needs datalake bucket information.

# Raw layer
# data "aws_ssm_parameter" "raw_bucket_name" {
#   name = "/${var.environment}/datalake/raw/bucket_name"
# }
#
# data "aws_ssm_parameter" "raw_bucket_arn" {
#   name = "/${var.environment}/datalake/raw/bucket_arn"
# }

# Staging layer
# data "aws_ssm_parameter" "staging_bucket_name" {
#   name = "/${var.environment}/datalake/staging/bucket_name"
# }
#
# data "aws_ssm_parameter" "staging_bucket_arn" {
#   name = "/${var.environment}/datalake/staging/bucket_arn"
# }

# ─────────────────────────────────────────────────────────────────────────────
# Example: Lambda Function ARNs
# ─────────────────────────────────────────────────────────────────────────────
# Uncomment if your Step Function invokes Lambda functions.
# Lambda functions deployed with aws-lambda-python-template export their ARNs.

# data "aws_ssm_parameter" "lambda_arns" {
#   for_each = toset(local.lambda_functions)
#   name     = "/${var.environment}/lambda/${each.value}/function_arn"
# }

# ─────────────────────────────────────────────────────────────────────────────
# Local variables for easy access (uncomment as needed)
# ─────────────────────────────────────────────────────────────────────────────
# locals {
#   # Datalake buckets
#   datalake = {
#     raw = {
#       bucket_name = data.aws_ssm_parameter.raw_bucket_name.value
#       bucket_arn  = data.aws_ssm_parameter.raw_bucket_arn.value
#     }
#     staging = {
#       bucket_name = data.aws_ssm_parameter.staging_bucket_name.value
#       bucket_arn  = data.aws_ssm_parameter.staging_bucket_arn.value
#     }
#   }
#
#   # Lambda ARNs map: function_name => arn
#   lambda_arns = {
#     for name in local.lambda_functions :
#     name => data.aws_ssm_parameter.lambda_arns[name].value
#   }
# }
