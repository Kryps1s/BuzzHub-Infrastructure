# =============
# --- Zips ---
# -------------

# Zip All Lambda Functions
data "archive_file" "get_event_by_id_lambda_zip" {
  type        = "zip"
  source_file = "../BuzzHub-API/get_event_by_id.py"
  output_path = "./zip/${terraform.workspace}_get_event_by_id.zip"
}

data "archive_file" "get_all_events_lambda_zip" {
  type        = "zip"
  source_file = "../BuzzHub-API/get_all_events.py"
  output_path = "./zip/${terraform.workspace}_get_all_events.zip"
}

# =============
# --- Lambdas ---
# -------------

# Create lambda function from zips.
resource "aws_lambda_function" "get_event_by_id_lambda" {
  function_name    = "${terraform.workspace}_get_event_by_id"
  filename         = data.archive_file.get_event_by_id_lambda_zip.output_path
  source_code_hash = data.archive_file.get_event_by_id_lambda_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "get_event_by_id.lambda_handler"
  environment {
    variables = {
      env = terraform.workspace
      region = var.region
    }
  }
}

resource "aws_lambda_function" "get_all_events_lambda" {
  function_name    = "${terraform.workspace}_get_all_events"
  filename         = data.archive_file.get_all_events_lambda_zip.output_path
  source_code_hash = data.archive_file.get_all_events_lambda_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "get_all_events.lambda_handler"
  environment {
    variables = {
      env = terraform.workspace
       region = var.region
    }
  }
}

