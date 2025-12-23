include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../../Terraform/templates/atlas/sqs"
}

# Generate module.tf with correct module path
generate "module" {
  path      = "module.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
module "sqs_queue" {
  source = "${get_repo_root()}/Terraform/module/sqs"

  # Basic configuration
  queue_name = var.queue_name
  fifo_queue = var.fifo_queue

  # FIFO-specific settings
  content_based_deduplication = var.content_based_deduplication
  deduplication_scope         = var.deduplication_scope
  fifo_throughput_limit       = var.fifo_throughput_limit

  # Queue behavior
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  message_retention_seconds   = var.message_retention_seconds
  delay_seconds               = var.delay_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds

  # Encryption
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled

  # Dead letter queue
  dead_letter_queue_arn = var.dead_letter_queue_arn
  max_receive_count     = var.max_receive_count

  # Policies
  queue_policy          = var.queue_policy
  redrive_allow_policy  = var.redrive_allow_policy
  use_redrive_policy_resource = var.use_redrive_policy_resource

  # Tags
  tags = var.tags
}
EOF
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
    ManagedBy   = "terraformer"
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


