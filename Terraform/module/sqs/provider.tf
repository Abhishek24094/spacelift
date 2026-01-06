# AWS Provider configuration
# Region can be set via AWS_REGION environment variable or provider configuration
provider "aws" {
  region = var.aws_region
}
