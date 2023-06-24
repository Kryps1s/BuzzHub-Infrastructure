resource "aws_appsync_graphql_api" "calendar" {
  name          = "CalendarAPI-${terraform.workspace}"
  authentication_type = "API_KEY"

schema = <<EOF
type Event {
  eventId: String!
  type: EventType!
  start: String!
  end: String!
  roles: [Role!]
  notes: EventNotes
}

enum EventType {
  MEETING
  COLLECTIVE
  BEEKEEPING
}

type Role {
  roleName: String!
  userName: String!
}

type EventNotes {
  inspection: String
  meeting: String
}

type Query {
  getEvent(eventId: String!): Event
  getAllEvents: [Event!]!
}

type Mutation {
  createEvent(input: EventInput!): Event!
  updateEvent(eventId: String!, input: EventInput!): Event!
  deleteEvent(eventId: String!): String!
}

input EventInput {
  type: EventType!
  start: String!
  end: String!
  roles: [RoleInput!]!
  notes: EventNotesInput
}

input EventNotesInput {
  inspection: String
  meeting: String
}

input RoleInput {
  roleName: String!
  userName: String!
}

EOF
}

resource "aws_appsync_api_key" "calendar" {
  api_id = aws_appsync_graphql_api.calendar.id
}

resource "aws_appsync_datasource" "calendar" {
  api_id          = aws_appsync_graphql_api.calendar.id
  name            = "Events${terraform.workspace}"
  type            = "AMAZON_DYNAMODB"
  service_role_arn = "arn:aws:iam::355764039214:role/appsync-dynamodb-role"

  dynamodb_config {
    table_name = aws_dynamodb_table.events.name
  }
}

