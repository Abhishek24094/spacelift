include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../../Terraform/templates/atlas/sqs"
}

inputs = {
  # Basic configuration
  queue_name = "atlas-queue-test"
  fifo_queue = false  # Set to true for FIFO queue

  # FIFO-specific settings (only applicable when fifo_queue = true)
  content_based_deduplication = false
  deduplication_scope         = "queue"  # Options: "messageGroup" or "queue"
  fifo_throughput_limit       = "perQueue"  # Options: "perQueue" or "perMessageGroupId"

  # Queue behavior
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600  # 4 days
  delay_seconds              = 0
  receive_wait_time_seconds  = 0  # Set to 0-20 for long polling

  # Encryption
  kms_master_key_id                 = null  # Set to KMS key ARN if using custom encryption
  kms_data_key_reuse_period_seconds = 300
  sqs_managed_sse_enabled           = true  # Enable SQS-managed SSE

  # Dead letter queue
  dead_letter_queue_arn = null  # Set to DLQ ARN if using dead letter queue
  max_receive_count     = 3

  # Policies
  queue_policy = null  # Set to JSON policy string if needed
  # Example queue policy:
  # queue_policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Effect = "Allow"
  #       Principal = "*"
  #       Action = "sqs:SendMessage"
  #       Resource = "*"
  #     }
  #   ]
  # })

  redrive_allow_policy         = null
  use_redrive_policy_resource  = false

  # Tags
  tags = {
    Environment = "staging"
    Region      = "ap-south-1"
    Project     = "atlas"
    ManagedBy   = "terraform"
  }
}
remote_state {
  backend = "s3"
  config = {
    bucket         = get_env("TF_STATE_BUCKET", "staging-setup-cloud-platform")
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = get_env("AWS_REGION", "ap-south-1")
    encrypt        = true
    dynamodb_table = get_env("TF_STATE_LOCK_TABLE", "terraform_lock_test")
  }
}

