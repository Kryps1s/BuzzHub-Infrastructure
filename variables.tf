variable "region" {
  description = "The AWS region where the resources will be provisioned"
  type        = string
  default     = "ca-central-1"
  } 

variable "developers" {
  type = list(string)
  default = ["Camille"]
}