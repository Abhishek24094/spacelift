terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

module "sqs_queue" {
  source = "../../../module/sqs"

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


