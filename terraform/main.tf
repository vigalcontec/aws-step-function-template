# =============================================================================
# Step Functions State Machine
# =============================================================================

# -----------------------------------------------------------------------------
# Step Functions State Machine
# -----------------------------------------------------------------------------
resource "aws_sfn_state_machine" "main" {
  name     = local.full_name
  role_arn = aws_iam_role.step_function.arn

  # ───────────────────────────────────────────────────────────────────────────
  # State Machine Definition
  # ───────────────────────────────────────────────────────────────────────────
  # This is a simple success workflow. Modify this definition for your use case.
  # Documentation: https://docs.aws.amazon.com/step-functions/latest/dg/concepts-amazon-states-language.html
  definition = jsonencode({
    Comment = "Step Function Template - Replace with your workflow"
    StartAt = "ProcessInput"
    States = {
      # ─────────────────────────────────────────────────────────────────────────
      # Step 1: Process Input (Pass state example)
      # ─────────────────────────────────────────────────────────────────────────
      ProcessInput = {
        Type    = "Pass"
        Comment = "Process and transform input data"
        Result = {
          status      = "processing"
          processedAt = "$$.State.EnteredTime"
        }
        ResultPath = "$.metadata"
        Next       = "Success"
      }

      # ─────────────────────────────────────────────────────────────────────────
      # Final Step: Success
      # ─────────────────────────────────────────────────────────────────────────
      Success = {
        Type    = "Succeed"
        Comment = "Workflow completed successfully"
      }

      # ─────────────────────────────────────────────────────────────────────────
      # Example: Lambda Task (uncomment and modify as needed)
      # ─────────────────────────────────────────────────────────────────────────
      # InvokeLambda = {
      #   Type     = "Task"
      #   Resource = local.lambda_arns["my-lambda-function"]
      #   Next     = "Success"
      #   Retry = [
      #     {
      #       ErrorEquals     = ["Lambda.ServiceException", "Lambda.AWSLambdaException"]
      #       IntervalSeconds = 2
      #       MaxAttempts     = 3
      #       BackoffRate     = 2
      #     }
      #   ]
      #   Catch = [
      #     {
      #       ErrorEquals = ["States.ALL"]
      #       Next        = "FailState"
      #     }
      #   ]
      # }

      # ─────────────────────────────────────────────────────────────────────────
      # Example: Fail State (uncomment if using error handling)
      # ─────────────────────────────────────────────────────────────────────────
      # FailState = {
      #   Type  = "Fail"
      #   Error = "WorkflowError"
      #   Cause = "Workflow failed after retries"
      # }
    }
  })

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.main.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  tracing_configuration {
    enabled = true
  }

  tags = merge(local.common_tags, {
    Name = local.full_name
  })
}

# -----------------------------------------------------------------------------
# CloudWatch Log Group for Step Function
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/states/${local.project_name}/stepfunction/${local.function_name}"
  retention_in_days = local.log_retention_days

  tags = local.common_tags
}
