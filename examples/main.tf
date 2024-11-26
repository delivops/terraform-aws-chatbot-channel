provider "aws" {
  region = "eu-west-1"
}

data "aws_iam_policy_document" "chatbot_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["chatbot.amazonaws.com"]
    }
  }
}

module "chatbot-role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.48.0"

  role_name                       = "chatbot-role"
  create_custom_role_trust_policy = true
  create_role                     = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AWSResourceExplorerReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchEventsReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  ]
  custom_role_trust_policy = data.aws_iam_policy_document.chatbot_assume_role_policy.json
}

module "aws_chatbot_channel" {
  source              = "delivops/chatbot-channel/aws"
  #version            = "0.0.1"

  slack_channel_name       = "aws-cost-anomalies"
  chatbot_workspace_name   = "xxxxx"
  chatbot_role_arn         = module.chatbot-role.iam_role_arn
  slack_channel_id         = "xxx"
  alert_type               = "cost-anomalies"
}