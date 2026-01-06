terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  # Backend configuration is handled by Spacelift via state-credentials.tf
  # Do not add a backend block here - Spacelift will generate it automatically
  # 
  # Configure the backend in Spacelift stack settings:
  # - Backend: s3
  # - Bucket: staging-setup-cloud-platform (or use state_bucket input variable)
  # - Key: sqs/${var.queue_name}/terraform.tfstate (uses queue name in path)
  # - Region: ap-south-1 (or use aws_region input variable)
  # - Encrypt: true
  # - DynamoDB Table: terraform_lock_test (or use state_lock_table input variable)
}



