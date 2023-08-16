resource "aws_s3_bucket" "terraform_state" {
   bucket = "terraform-8zmqsm"
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_ownership_controls" "terraform_state_acl" {
  bucket = "terraform-8zmqsm"
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "terraform_state_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.terraform_state_acl]
  bucket = aws_s3_bucket.terraform_state.id
  lifecycle {
    ignore_changes = [
      acl
    ]
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}