# resource "aws_s3_bucket" "terraform-8zmqsm" {
#    bucket = "terraform-8zmqsm"
#    acl = "private"  
# }

# resource "aws_s3_bucket_public_access_block" "terraform-8zmqsm" {
#   bucket = aws_s3_bucket.terraform-8zmqsm.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }


# resource "aws_dynamodb_table" "terraform-lock" {
#   name         = "terraform-lock"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }