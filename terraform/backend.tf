# =============================================================================
# Backend Configuration
# =============================================================================
# Backend is configured via -backend-config flags in CI/CD
# Example:
#   terraform init \
#     -backend-config="bucket=tfstate-mycompany-dev-123456789012" \
#     -backend-config="key=stepfunction/my-step-function/terraform.tfstate" \
#     -backend-config="region=eu-west-1" \
#     -backend-config="encrypt=true"

terraform {
  backend "s3" {}
}
