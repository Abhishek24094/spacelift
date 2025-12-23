# SQS Queue Configuration

This Terragrunt configuration creates an SQS queue using the SQS Terraform module.

## Configuration Options

### Standard Queue Example
```hcl
queue_name = "atlas-queue"
fifo_queue = false
```

### FIFO Queue Example
```hcl
queue_name = "atlas-queue"
fifo_queue = true
content_based_deduplication = true
```

## Key Variables

- `queue_name`: Name of the queue (will automatically append `.fifo` for FIFO queues)
- `fifo_queue`: Boolean to create FIFO queue (default: false)
- `visibility_timeout_seconds`: Time a message is hidden after being received (default: 30)
- `message_retention_seconds`: How long messages are retained (default: 345600 = 4 days)
- `dead_letter_queue_arn`: ARN of dead letter queue if using DLQ
- `sqs_managed_sse_enabled`: Enable SQS-managed server-side encryption (default: false)

## Usage

```bash
cd terragrunt/staging-setup/ap-south-1/atlas/sqs
terragrunt plan
terragrunt apply
```


