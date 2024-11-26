![image info](logo.jpeg)

# Terraform-aws-chatbot

This Terraform module creates an Amazon SNS topic and configures an AWS Chatbot Slack channel for different types of alerts. The module supports three alert types: budget, cloudwatch, and anomalies.

## Installation

To use this module, you need to have Terraform installed. You can find installation instructions on the Terraform website.

## Features

- Creates an SNS topic with a configurable name
- Supports different alert types with conditional policy application
- Configures AWS Chatbot integration with Slack
- Applies ReadOnlyAccess guardrail policy for security

Include this repository as a module in your existing terraform code:

```python

################################################################################
# AWS CHATBOT
################################################################################


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

  role_name                       = "chatbot-role-test"
  create_custom_role_trust_policy = true
  create_role                     = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AWSResourceExplorerReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchEventsReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  ]

  custom_role_trust_policy = data.aws_iam_policy_document.chatbot_assume_role_policy.json
}
module "anomalies_sns_chatbot_topic" {
  source              = "delivops/chatbot/aws"
  #version            = "0.0.1"

  slack_channel_name       = "anomalies-slack"
  chatbot_workspace_name   = "Delivops"
  chatbot_role_arn         = module.chatbot-role.iam_role_arn
  slack_channel_id         = "C0123ABC456"
  alert_type               = "anomalies"
}

```
