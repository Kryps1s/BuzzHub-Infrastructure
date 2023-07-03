resource "aws_appsync_graphql_api" "calendar" {
  name          = "${terraform.workspace}_calendar"
  authentication_type = "API_KEY"
  schema = file("schemas/calendar.graphql")
}

resource "aws_appsync_api_key" "calendar" {
  api_id = aws_appsync_graphql_api.calendar.id
}

# Create data source in appsync from lambda function.
resource "aws_appsync_datasource" "get_event_by_id_datasource" {
  name             = "${terraform.workspace}_get_event_by_id_datasource"
  api_id           = aws_appsync_graphql_api.calendar.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.getEventById_lambda.arn
  }
}

# Create resolvers.
resource "aws_appsync_resolver" "getEvent_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Query"
  field       = "getEvent"
  data_source = aws_appsync_datasource.get_event_by_id_datasource.name
}