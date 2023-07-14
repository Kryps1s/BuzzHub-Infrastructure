#create a bucket to hold lambda layer
resource "aws_s3_bucket" "lambda_layer_buzzhub_dependency" {
  bucket = "${terraform.workspace}-lambda-layer-buzzhub-dependency"
}

resource "aws_s3_bucket_ownership_controls" "buzzhub_dependencies_acl" {
  bucket = aws_s3_bucket.lambda_layer_buzzhub_dependency.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "versioning_buzzhub_dependencies" {
  bucket = aws_s3_bucket.lambda_layer_buzzhub_dependency.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "buzzhub_dependencies_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.buzzhub_dependencies_acl]

  bucket = aws_s3_bucket.lambda_layer_buzzhub_dependency.id
  acl    = "private"
}

#add the layer to the bucket
resource "aws_s3_object" "lambda_layer_buzzhub_dependency" {
  bucket = aws_s3_bucket.lambda_layer_buzzhub_dependency.id
  key    = "dependencies"
  source = "./lambda_layers/${terraform.workspace}_dependencies.zip"
  etag   = filemd5("./lambda_layers/${terraform.workspace}_dependencies.zip")
}