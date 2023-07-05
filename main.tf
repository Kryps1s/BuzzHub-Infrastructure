terraform {
  required_version = "1.5.1"
 required_providers {
   aws = {
     source = "hashicorp/aws"
     version = "5.4.0"
   }
   archive = {
      source = "hashicorp/archive"
      version = "2.4.0"
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



