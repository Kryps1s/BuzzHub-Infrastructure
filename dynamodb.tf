resource "aws_dynamodb_table" "events" {
  name           = "Events-${terraform.workspace}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "eventId"

  attribute {
    name = "eventId"
    type = "S"
  }

  attribute {
    name = "type"
    type = "S"
  }

  attribute {
    name = "start"
    type = "S"
  }

  global_secondary_index {
    name               = "upcomingEvent"
    hash_key           = "type"
    range_key          = "start"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "eventType"
    hash_key           = "type"
    projection_type    = "ALL"
  }

}