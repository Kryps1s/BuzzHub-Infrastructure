# =============
# --- Groups ---
# -------------

resource "aws_iam_group" "developer_group" {
  name = "Developer"
  path = "/"
}

# =============
# --- Roles ---
# -------------

# Lambda role

data "aws_iam_policy_document" "iam_lambda_role_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_lambda_role" {
  name               = "${terraform.workspace}_iam_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.iam_lambda_role_document.json
}

# Appsync role

data "aws_iam_policy_document" "iam_appsync_role_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_appsync_role" {
  name               = "${terraform.workspace}_iam_appsync_role"
  assume_role_policy = data.aws_iam_policy_document.iam_appsync_role_document.json
}

# ================
# --- Policies ---
# ----------------

# Invoke Lambda policy

data "aws_iam_policy_document" "iam_invoke_lambda_policy_document" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:*:*:function:${terraform.workspace}*"]
  }
}

# Invoke DynamoDb policy

data "aws_iam_policy_document" "dynamodb_policy" {
  statement {
    sid       = "AllowAccessToDevTables"
    effect    = "Allow"
    actions   = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${terraform.workspace}*"]
  }
}

resource "aws_iam_policy" "iam_invoke_lambda_policy" {
  name   = "${terraform.workspace}_iam_invoke_lambda_policy"
  policy = data.aws_iam_policy_document.iam_invoke_lambda_policy_document.json
}

resource "aws_iam_policy" "iam_access_dynamodb_policy" {
  name        = "${terraform.workspace}_iam_access_dynamodb_policy"
  policy      = data.aws_iam_policy_document.dynamodb_policy.json
}

resource "aws_iam_policy" "appsync_developer_policy" {
  name   = "dev_appsync_developer_policy"
  policy = data.aws_iam_policy_document.appsync_developer_policy.json
}

resource "aws_iam_policy" "dynamodb_developer_policy" {
  name   = "dev_dynamodb_developer_policy"
  policy = data.aws_iam_policy_document.dynamodb_developer_policy.json
}
  
resource "aws_iam_policy" "lambda_developer_policy" {
  name   = "dev_lambda_developer_policy"
  policy = data.aws_iam_policy_document.lambda_developer_policy.json
}
  
resource "aws_iam_policy" "s3_developer_policy" {
  name   = "dev_s3_developer_policy"
  policy = data.aws_iam_policy_document.s3_developer_policy.json
}

# ===================
# --- Attachments ---
# -------------------

# Attach Invoke Lambda policy to AppSync role.

resource "aws_iam_role_policy_attachment" "appsync_invoke_lambda" {
  role       = aws_iam_role.iam_appsync_role.name
  policy_arn = aws_iam_policy.iam_invoke_lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.iam_lambda_role.name
  policy_arn = aws_iam_policy.iam_access_dynamodb_policy.arn
}

data "aws_iam_policy_document" "appsync_developer_policy" {
  statement {
    effect    = "Allow"
    actions   = ["appsync:*"]
    resources = ["arn:aws:appsync:ca-central-1:355764039214:apis/jycd7c2wrfd7pjpzc2ddvea7o4/*"]
  }
}

data "aws_iam_policy_document" "dynamodb_developer_policy" {
  statement {
      effect    = "Allow"
      actions   = ["dynamodb:*"]
      resources = ["arn:aws:dynamodb:${var.region}:355764039214:table/dev*"]
    } 
 }

data "aws_iam_policy_document" "lambda_developer_policy" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:*"]
    resources = ["arn:aws:lambda:${var.region}:355764039214:function:dev*"]
  }
}

data "aws_iam_policy_document" "s3_developer_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:lambda:${var.region}:355764039214:dev*"]
  }
}

resource "aws_iam_policy" "developer_list_tables_policy" {
  name        = "DeveloperListTablesPolicy"
  description = "IAM policy to allow listing table names in required aws services"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListDynamoDBTables",
      "Effect": "Allow",
      "Action": "dynamodb:ListTables",
      "Resource": "*"
    },
    {
      "Sid": "GetAccountSettings",
      "Effect": "Allow",
      "Action": "lambda:GetAccountSettings",
      "Resource": "*"
    },
    {
      "Sid": "ListLambdaFunctions",
      "Effect": "Allow",
      "Action": "lambda:ListFunctions",
      "Resource": "*"
    },
    {
      "Sid": "ListS3Buckets",
      "Effect": "Allow",
      "Action": "s3:ListAllMyBuckets",
      "Resource": "*"
    },
    {
      "Sid": "ListGraphqlApis",
      "Effect": "Allow",
      "Action": "appsync:ListGraphqlApis",
      "Resource": "*"
    }

  ]
}
EOF
}


resource "aws_iam_group_policy_attachment" "appsync_attachment" {
  group      = aws_iam_group.developer_group.name
  policy_arn = aws_iam_policy.appsync_developer_policy.arn
}

resource "aws_iam_group_policy_attachment" "dynamodb_attachment" {
  group      = aws_iam_group.developer_group.name
  policy_arn = aws_iam_policy.dynamodb_developer_policy.arn
}

resource "aws_iam_group_policy_attachment" "lambda_attachment" {
  group      = aws_iam_group.developer_group.name
  policy_arn = aws_iam_policy.lambda_developer_policy.arn
}

resource "aws_iam_group_policy_attachment" "s3_attachment" {
  group      = aws_iam_group.developer_group.name
  policy_arn = aws_iam_policy.s3_developer_policy.arn
}
resource "aws_iam_group_policy_attachment" "developer_list_tables_attachment" {
  group      = aws_iam_group.developer_group.name
  policy_arn = aws_iam_policy.developer_list_tables_policy.arn
}

#===================
#--- Users ---
#-------------------

resource "aws_iam_user" "developer_users" {
  count = length(var.developers)
  name  = var.developers[count.index]
  path  = "/"

  depends_on = [aws_iam_group.developer_group]

  lifecycle {
    ignore_changes = [
      tags,
      tags_all
    ]
  }
}

resource "aws_iam_user_group_membership" "developer_memberships" {
  count = length(var.developers)
  user   = aws_iam_user.developer_users[count.index].name
  groups = [aws_iam_group.developer_group.name]

  depends_on = [aws_iam_user.developer_users]
}