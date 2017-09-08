variable "region" {}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "/Users/sarahconnor/.aws/credentials"
  profile                 = "default"
}