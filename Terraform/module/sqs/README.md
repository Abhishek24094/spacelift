# SQS Terraform Module

A comprehensive Terraform module for creating AWS SQS queues that supports both standard and FIFO queues with all possible configuration options.

## Features

- ✅ Support for both Standard and FIFO queues
- ✅ Content-based deduplication for FIFO queues
- ✅ Dead Letter Queue (DLQ) configuration
- ✅ KMS encryption support
- ✅ SQS-managed SSE encryption
- ✅ Queue policies
- ✅ Redrive allow policies
- ✅ Long polling support
- ✅ Message retention configuration
- ✅ Visibility timeout configuration
- ✅ Delay seconds configuration

## Usage

### Standard Queue

```hcl
module "sqs_queue" {
  source = "./module/sqs"

  queue_name = "my-standard-queue"
  fifo_queue = false

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  sqs_managed_sse_enabled    = true

  tags = {
    Environment = "production"
  }
}
```

### FIFO Queue

```hcl
module "sqs_fifo_queue" {
  source = "./module/sqs"

  queue_name = "my-fifo-queue"
  fifo_queue = true

  content_based_deduplication = true
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  sqs_managed_sse_enabled    = true

  tags = {
    Environment = "production"
  }
}
```

### With Dead Letter Queue

```hcl
module "sqs_queue_with_dlq" {
  source = "./module/sqs"

  queue_name = "my-queue"
  fifo_queue = false

  dead_letter_queue_arn = "arn:aws:sqs:us-east-1:123456789012:my-dlq"
  max_receive_count     = 5

  visibility_timeout_seconds = 30
  sqs_managed_sse_enabled    = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| queue_name | The name of the SQS queue | `string` | n/a | yes |
| fifo_queue | Boolean designating a FIFO queue | `bool` | `false` | no |
| content_based_deduplication | Enables content-based deduplication for FIFO queues | `bool` | `false` | no |
| deduplication_scope | Message deduplication scope (messageGroup or queue) | `string` | `"queue"` | no |
| fifo_throughput_limit | FIFO throughput limit (perQueue or perMessageGroupId) | `string` | `"perQueue"` | no |
| visibility_timeout_seconds | The visibility timeout for the queue | `number` | `30` | no |
| message_retention_seconds | The number of seconds Amazon SQS retains a message | `number` | `345600` | no |
| delay_seconds | The time in seconds that delivery will be delayed | `number` | `0` | no |
| receive_wait_time_seconds | Long polling wait time | `number` | `0` | no |
| kms_master_key_id | The ID of an AWS-managed or custom CMK | `string` | `null` | no |
| kms_data_key_reuse_period_seconds | KMS data key reuse period | `number` | `300` | no |
| dead_letter_queue_arn | The ARN of the dead-letter queue | `string` | `null` | no |
| max_receive_count | Number of times a message is delivered before moving to DLQ | `number` | `3` | no |
| sqs_managed_sse_enabled | Enable SQS-managed SSE | `bool` | `false` | no |
| queue_policy | The JSON policy for the SQS queue | `string` | `null` | no |
| redrive_allow_policy | The JSON policy for RedriveAllowPolicy | `string` | `null` | no |
| use_redrive_policy_resource | Use aws_sqs_redrive_policy resource | `bool` | `false` | no |
| tags | A map of tags to assign to the queue | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| queue_id | The URL for the created Amazon SQS queue |
| queue_arn | The ARN of the SQS queue |
| queue_name | The name of the SQS queue |
| queue_url | The URL for the created Amazon SQS queue |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |



