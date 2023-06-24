terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }
 backend "s3" {
    bucket         	   = "terraform-8zmqsm"
    key                = "terraform.tfstate"
    region         	   = "ca-central-1"
    encrypt        	   = true
    dynamodb_table     = "terraform-lock"
  }
}
    
provider "aws" {
  region = "ca-central-1"
  shared_credentials_files = ["$HOME/.aws/credentials"]
}



