output "queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.sqs_queue.queue_id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.sqs_queue.queue_arn
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = module.sqs_queue.queue_name
}

output "queue_url" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.sqs_queue.queue_url
}


