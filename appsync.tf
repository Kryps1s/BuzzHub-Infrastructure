resource "aws_appsync_graphql_api" "calendar" {
  name          = "${terraform.workspace}_calendar"
  authentication_type = "AWS_LAMBDA"
  schema = file("schemas/calendar.graphql")
  lambda_authorizer_config {
    authorizer_result_ttl_in_seconds = 0
    authorizer_uri = aws_lambda_function.auth_lambda.arn
  }
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
    function_arn = aws_lambda_function.get_event_by_id_lambda.arn
  }
}

resource "aws_appsync_datasource" "get_events_datasource" {
  name             = "${terraform.workspace}_get_events_datasource"
  api_id           = aws_appsync_graphql_api.calendar.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.get_events_lambda.arn
  }
}

resource "aws_appsync_datasource" "get_trello_members_datasource" {
  name             = "${terraform.workspace}_get_trello_members_datasource"
  api_id           = aws_appsync_graphql_api.calendar.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.get_trello_members_lambda.arn
  }
}

resource "aws_appsync_datasource" "get_meeting_agenda_datasource" {
  name             = "${terraform.workspace}_get_meeting_agenda_datasource"
  api_id           = aws_appsync_graphql_api.calendar.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.get_meeting_agenda_lambda.arn
  }
}

resource "aws_appsync_datasource" "create_user_datasource" {
  name             = "${terraform.workspace}_create_user_datasource"
  api_id           = aws_appsync_graphql_api.calendar.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.create_user_lambda.arn
  }
}

resource "aws_appsync_datasource" "login_datasource" {
  name             = "${terraform.workspace}_login_datasource"
  api_id           = aws_appsync_graphql_api.calendar.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.login_lambda.arn
  }
}

resource "aws_appsync_datasource" "save_beekeeping_report_datasource" {
  name             = "${terraform.workspace}_save_beekeeping_report_datasource"
  api_id           = aws_appsync_graphql_api.calendar.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.save_beekeeping_report_lambda.arn
  }
}

resource "aws_appsync_datasource" "update_event_datasource" {
  name             = "${terraform.workspace}_update_event_datasource"
  api_id           = aws_appsync_graphql_api.calendar.id
  service_role_arn = aws_iam_role.iam_appsync_role.arn
  type             = "AWS_LAMBDA"
  lambda_config {
    function_arn = aws_lambda_function.update_event_lambda.arn
  }
  
}

# Create resolvers.
resource "aws_appsync_resolver" "get_event_by_id_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Query"
  field       = "getEventById"
  data_source = aws_appsync_datasource.get_event_by_id_datasource.name
}

resource "aws_appsync_resolver" "get_events_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Query"
  field       = "getEvents"
  data_source = aws_appsync_datasource.get_events_datasource.name
}

resource "aws_appsync_resolver" "get_trello_members_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Query"
  field       = "getTrelloMembers"
  data_source = aws_appsync_datasource.get_trello_members_datasource.name
}

resource "aws_appsync_resolver" "get_meeting_agenda_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Query"
  field       = "getMeetingAgenda"
  data_source = aws_appsync_datasource.get_meeting_agenda_datasource.name
}

resource "aws_appsync_resolver" "create_user_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Mutation"
  field       = "createUser"
  data_source = aws_appsync_datasource.create_user_datasource.name
}

resource "aws_appsync_resolver" "login_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Mutation"
  field       = "login"
  data_source = aws_appsync_datasource.login_datasource.name
}

resource "aws_appsync_resolver" "save_beekeeping_report_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Mutation"
  field       = "saveBeekeepingReport"
  data_source = aws_appsync_datasource.save_beekeeping_report_datasource.name
}

resource "aws_appsync_resolver" "update_event_resolver" {
  api_id      = aws_appsync_graphql_api.calendar.id
  type        = "Mutation"
  field       = "updateEvent"
  data_source = aws_appsync_datasource.update_event_datasource.name
  
}