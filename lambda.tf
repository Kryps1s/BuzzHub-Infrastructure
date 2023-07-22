# =============
# --- Zips ---
# -------------

# Zip All Lambda Functions
data "archive_file" "boilerplate_zip" {
  type        = "zip"
  source_file = "./lambda_layers/lambda.py"
  output_path = "./zip/lambda.zip"
}

# =============
# --- Lambdas ---
# -------------

# Create lambda function from zips.
resource "aws_lambda_function" "get_event_by_id_lambda" {
  function_name    = "${terraform.workspace}_get_event_by_id"
  filename         = data.archive_file.boilerplate_zip.output_path
  source_code_hash = data.archive_file.boilerplate_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "get_event_by_id.lambda_handler"
  environment {
    variables = {
      env = terraform.workspace
      region = var.region
    }
  }
  lifecycle {
    ignore_changes = [source_code_hash, filename]
  }
}

resource "aws_lambda_function" "get_events_lambda" {
  function_name    = "${terraform.workspace}_get_events"
  filename         = data.archive_file.boilerplate_zip.output_path
  source_code_hash = data.archive_file.boilerplate_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "get_events.lambda_handler"
  #attach the layer to the lambda
  layers = [aws_lambda_layer_version.buzzhub_dependencies.arn]
  lifecycle {
    ignore_changes = [
      source_code_hash,environment,filename
    ]
  }
}

resource "aws_lambda_function" "get_trello_members_lambda" {
  function_name    = "${terraform.workspace}_get_trello_members"
  filename         = "./zip/lambda.zip"
  source_code_hash = data.archive_file.boilerplate_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "get_trello_members.lambda_handler"
  #attach the layer to the lambda
  layers = [aws_lambda_layer_version.buzzhub_dependencies.arn]
  lifecycle {
    ignore_changes = [
      source_code_hash,environment,filename
    ]
  }
}
resource "aws_lambda_function" "create_user_lambda" {
  function_name    = "${terraform.workspace}_create_user"
  filename         = "./zip/lambda.zip"
  source_code_hash = data.archive_file.boilerplate_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "create_user.lambda_handler"
  #attach the layer to the lambda
  layers = [aws_lambda_layer_version.buzzhub_dependencies.arn]
  lifecycle {
    ignore_changes = [
      source_code_hash,environment
    ]
  }
}
resource "aws_lambda_function" "login_lambda" {
  function_name    = "${terraform.workspace}_login"
  filename         = "./zip/lambda.zip"
  source_code_hash = data.archive_file.boilerplate_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "login.lambda_handler"
  #attach the layer to the lambda
  layers = [aws_lambda_layer_version.buzzhub_dependencies.arn]
  #specify which layer version to use
  lifecycle {
    ignore_changes = [
      source_code_hash,environment
    ]
  }
}

resource "aws_lambda_layer_version" "buzzhub_dependencies" {
  layer_name = "${terraform.workspace}_buzzhub_dependencies"
  s3_bucket  = aws_s3_bucket.lambda_layer_buzzhub_dependency.id
  s3_key     = aws_s3_object.lambda_layer_buzzhub_dependency.id
  compatible_runtimes = [
    "python3.10",
  ]
}