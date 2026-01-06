terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  # Backend configuration - Spacelift will configure this
  # Recommended backend configuration in Spacelift:
  # backend = "s3"
  # bucket  = <TF_STATE_BUCKET> (e.g., "staging-setup-cloud-platform")
  # key     = "sqs/${var.queue_name}/terraform.tfstate" (uses queue name in path)
  # region  = <AWS_REGION> (e.g., "ap-south-1")
  # encrypt = true
  # dynamodb_table = <TF_STATE_LOCK_TABLE> (e.g., "terraform_lock_test")
  backend "s3" {
    # These values will be provided by Spacelift backend configuration
    # Key should be: sqs/${var.queue_name}/terraform.tfstate
   bucket  = "staging-setup-cloud-platform"
   key     = "sqs/${var.queue_name}/terraform.tfstate"
   region  = "ap-south-1"
  encrypt = true
  dynamodb_table = "terraform_lock_test"
  }
}



