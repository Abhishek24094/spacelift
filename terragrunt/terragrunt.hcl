# Root Terragrunt configuration
# This file is used by child terragrunt.hcl files via find_in_parent_folders()

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

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "${get_env("AWS_REGION", "ap-south-1")}"
}
EOF
}



