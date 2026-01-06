variable "aws_region" {
  description = "The AWS region where the SQS queue will be created"
  type        = string
  default     = "ap-south-1"
}

variable "queue_name" {
  description = "The name of the SQS queue"
  type        = string
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue. If not set, it defaults to false making it a standard queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues. For more information, see the related attribute in the AWS SQS API Reference"
  type        = bool
  default     = false
}

variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level. Valid values are: `messageGroup` and `queue`"
  type        = string
  default     = "queue"
  validation {
    condition     = contains(["messageGroup", "queue"], var.deduplication_scope)
    error_message = "deduplication_scope must be either 'messageGroup' or 'queue'."
  }
}

variable "fifo_throughput_limit" {
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values are: `perQueue` and `perMessageGroupId`"
  type        = string
  default     = "perQueue"
  validation {
    condition     = contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
    error_message = "fifo_throughput_limit must be either 'perQueue' or 'perMessageGroupId'."
  }
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  type        = number
  default     = 30
  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "visibility_timeout_seconds must be between 0 and 43200."
  }
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = 345600
  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be between 60 and 1209600."
  }
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  type        = number
  default     = 0
  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "delay_seconds must be between 0 and 900."
  }
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  type        = number
  default     = 0
  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "receive_wait_time_seconds must be between 0 and 20."
  }
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK"
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 (1 minute) and 86,400 (24 hours)"
  type        = number
  default     = 300
  validation {
    condition     = var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400
    error_message = "kms_data_key_reuse_period_seconds must be between 60 and 86400."
  }
}

variable "dead_letter_queue_arn" {
  description = "The ARN of the dead-letter queue to which Amazon SQS moves messages after the value of maxReceiveCount is exceeded"
  type        = string
  default     = null
}

variable "max_receive_count" {
  description = "The number of times a message is delivered to the source queue before being moved to the dead-letter queue"
  type        = number
  default     = 3
  validation {
    condition     = var.max_receive_count > 0
    error_message = "max_receive_count must be greater than 0."
  }
}

variable "sqs_managed_sse_enabled" {
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys"
  type        = bool
  default     = false
}

variable "queue_policy" {
  description = "The JSON policy for the SQS queue"
  type        = string
  default     = null
}

variable "redrive_allow_policy" {
  description = "The JSON policy to set up the RedriveAllowPolicy parameter, which specifies the source queue or queues that can send messages to this queue"
  type        = string
  default     = null
}

variable "use_redrive_policy_resource" {
  description = "Whether to use the aws_sqs_redrive_policy resource instead of inline redrive_policy. Set to true if you want to manage redrive policy separately"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the queue"
  type        = map(string)
  default     = {}
}



