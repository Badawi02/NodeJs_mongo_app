# Configure the AWS Provider
provider "aws" {
  region = var.region
  shared_config_files      = ["/home/ahmed/.aws/config"]
  shared_credentials_files = ["/home/ahmed/.aws/credentials"]
}