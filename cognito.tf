#management of cognito user pools
resource "aws_cognito_user_pool" "user_pool" {
    name = "${terraform.workspace}-users"
    username_attributes = ["email"]
    auto_verified_attributes = []
    tags = {}
    deletion_protection = "ACTIVE"
    email_configuration {
        email_sending_account = "DEVELOPER"
        from_email_address = "BuzzHub <no-reply@buzzhub.cc>"
        source_arn = "arn:aws:ses:ca-central-1:355764039214:identity/buzzhub.cc" #SES to be added to tf... if aws ever approves my request
    }
    account_recovery_setting {
        recovery_mechanism {
            name = "verified_email"
            priority = 1
        }
    }
    schema {
        name = "email"
        attribute_data_type = "String"
        mutable = true
        required = true
        developer_only_attribute = false
        string_attribute_constraints {
            min_length = 0
            max_length = 2048
        }
    }
    schema {
        name = "name"
        attribute_data_type = "String"
        mutable = true
        required = true
        developer_only_attribute = false
        string_attribute_constraints {
            min_length = 0
            max_length = 2048
        }
    }
    schema {
        name = "trello"
        attribute_data_type = "String"
        mutable = true
        required = false
        developer_only_attribute = false
        string_attribute_constraints {
            min_length = 1
        }
    }
    username_configuration {
        case_sensitive = false
    }
}