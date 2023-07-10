# =============
# --- SES Simple Email Service ---
# for managing email addresses and sending emails
# -------------

# add domain to SES
resource "aws_ses_domain_identity" "domain" {
  domain = var.domain
}

# verify domain
resource "aws_ses_domain_identity_verification" "domain" {
  domain = var.domain
}

# add email address to SES
resource "aws_ses_email_identity" "email" {
  email = "hello@${var.domain}"
}

# verify email address
resource "aws_ses_email_identity_verification" "email" {
  email = "hello@${var.domain}"
}

# add DKIM to SES
resource "aws_ses_domain_dkim" "domain" {
  domain = var.domain
}

#add mail from to SES
resource "aws_ses_domain_mail_from" "domain" {
  domain = var.domain
  mail_from_domain = var.domain
  behavior_on_mx_failure = "UseDefaultValue"
}
