resource "aws_sqs_queue" "this" {
  name                        = var.fifo_queue ? "${var.queue_name}.fifo" : var.queue_name
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null
  deduplication_scope         = var.fifo_queue ? var.deduplication_scope : null
  fifo_throughput_limit       = var.fifo_queue ? var.fifo_throughput_limit : null

  # Visibility timeout
  visibility_timeout_seconds = var.visibility_timeout_seconds

  # Message retention
  message_retention_seconds = var.message_retention_seconds

  # Delivery delay
  delay_seconds = var.delay_seconds

  # Receive message wait time (long polling)
  receive_wait_time_seconds = var.receive_wait_time_seconds

  # Encryption
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  # Dead letter queue
  redrive_policy = var.dead_letter_queue_arn != null ? jsonencode({
    deadLetterTargetArn = var.dead_letter_queue_arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  # Server-side encryption
  sqs_managed_sse_enabled = var.sqs_managed_sse_enabled

  # Tags
  tags = merge(
    var.tags,
    {
      Name = var.fifo_queue ? "${var.queue_name}.fifo" : var.queue_name
    }
  )
}

# Queue policy
resource "aws_sqs_queue_policy" "this" {
  count     = var.queue_policy != null ? 1 : 0
  queue_url = aws_sqs_queue.this.id

  policy = var.queue_policy
}

# Redrive allow policy (for FIFO queues)
resource "aws_sqs_redrive_allow_policy" "this" {
  count     = var.fifo_queue && var.redrive_allow_policy != null ? 1 : 0
  queue_url = aws_sqs_queue.this.id

  redrive_allow_policy = var.redrive_allow_policy
}

# Redrive policy (alternative to inline redrive_policy)
resource "aws_sqs_redrive_policy" "this" {
  count     = var.dead_letter_queue_arn != null && var.use_redrive_policy_resource ? 1 : 0
  queue_url = aws_sqs_queue.this.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = var.dead_letter_queue_arn
    maxReceiveCount     = var.max_receive_count
  })
}


