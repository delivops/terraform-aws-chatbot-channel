![image info](logo.jpeg)

# Terraform-aws-chatbot-channel

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
# AWS CHATBOT-CHANNEL
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

module "aws_chatbot_channel" {
  source              = "delivops/chatbot-channel/aws"
  #version            = "0.0.1"

  slack_channel_name       = "aws-cost-anomalies"
  chatbot_workspace_name   = "xxxxx"
  chatbot_role_arn         = module.chatbot-role.iam_role_arn
  slack_channel_id         = "xxx"
  alert_type               = "cost-anomalies"
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_chatbot_slack_channel_configuration.aws-slack-channel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/chatbot_slack_channel_configuration) | resource |
| [aws_sns_topic.aws-sns-topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.aws-sns-topic-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_chatbot_slack_workspace.workspace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/chatbot_slack_workspace) | data source |
| [aws_iam_policy_document.aws-budget-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_type"></a> [alert\_type](#input\_alert\_type) | alert type | `string` | n/a | yes |
| <a name="input_chatbot_role_arn"></a> [chatbot\_role\_arn](#input\_chatbot\_role\_arn) | chatbot role arn | `string` | n/a | yes |
| <a name="input_chatbot_workspace_name"></a> [chatbot\_workspace\_name](#input\_chatbot\_workspace\_name) | workspace | `string` | n/a | yes |
| <a name="input_slack_channel_id"></a> [slack\_channel\_id](#input\_slack\_channel\_id) | slack channel id | `string` | n/a | yes |
| <a name="input_slack_channel_name"></a> [slack\_channel\_name](#input\_slack\_channel\_name) | slack channel name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the AWS SNS topic. |
<!-- END_TF_DOCS -->