data "archive_file" "getEventById_lambda_zip" {
  type        = "zip"
  source_file = "../BuzzHub-API/getEventById.py"
  output_path = "./zip/${terraform.workspace}_getEventById.zip"
}

# Create lambda function from zip file, with lambda role.
resource "aws_lambda_function" "getEventById_lambda" {
  function_name    = "${terraform.workspace}_getEventById"
  filename         = data.archive_file.getEventById_lambda_zip.output_path
  source_code_hash = data.archive_file.getEventById_lambda_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "getEventById.lambda_handler"
}

data "archive_file" "getAllEvents_lambda_zip" {
  type        = "zip"
  source_file = "../BuzzHub-API/getAllEvents.py"
  output_path = "./zip/${terraform.workspace}_getAllEvents.zip"
}

resource "aws_lambda_function" "getAllEvents_lambda" {
  function_name    = "${terraform.workspace}_getAllEvents"
  filename         = data.archive_file.getAllEvents_lambda_zip.output_path
  source_code_hash = data.archive_file.getAllEvents_lambda_zip.output_base64sha256
  role             = aws_iam_role.iam_lambda_role.arn
  runtime          = "python3.10"
  handler          = "getAllEvents.lambda_handler"
}