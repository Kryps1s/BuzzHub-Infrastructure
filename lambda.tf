# =============
# --- Zips ---
# -------------

# Zip All Lambda Functions
data "archive_file" "get_event_by_id_lambda_zip" {
  type        = "zip"
  source_file = "../BuzzHub-API/lambdas/get_event_by_id.py"
  output_path = "./zip/${terraform.workspace}_get_event_by_id.zip"
}

data "archive_file" "get_events_lambda_zip" {
  type        = "zip"
  source_file = "../BuzzHub-API/lambdas/get_events.py"
  output_path = "./zip/${terraform.workspace}_get_events.zip"
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
  lifecycle {
    ignore_changes = [source_code_hash]
  }
}

resource "aws_lambda_function" "get_events_lambda" {
  function_name    = "${terraform.workspace}_get_events"
  filename         = data.archive_file.get_events_lambda_zip.output_path
  source_code_hash = data.archive_file.get_events_lambda_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "get_events.lambda_handler"
  environment {
    variables = {
      env = terraform.workspace
      region = var.region
      TRELLO_BOARD_BEEKEEPING = "tVNzQnNQ"
      TRELLO_BOARD_COLLECTIVE = "RRqKnGAA"
      TRELLO_BOARD_MEETING = "KH88ovyS"
      TRELLO_BOARD_TEMPLATES = "KH88ovyS"
      BEEKEEPING_BOARD_ID = "61f889ff737a1d7b1031bb9d"
      MEETING_BOARD_ID = "6400b6b7e4675653e5d7aff9"
      COLLECTIVE_BOARD_ID = "61f8890dc569b714275d8a50"
    }
  }
  #attach the layer to the lambda
  layers = [aws_lambda_layer_version.buzzhub_dependencies.arn]
  lifecycle {
    ignore_changes = [
      source_code_hash,
      environment.0.variables["TRELLO_KEY"],
      environment.0.variables["TRELLO_TOKEN"]
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