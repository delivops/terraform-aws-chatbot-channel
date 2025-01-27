terraform {
  required_providers {
    aws = {}
  }
}
data "aws_chatbot_slack_workspace" "workspace" {
  slack_team_name = var.chatbot_workspace_name
}
data "aws_iam_policy_document" "aws-budget-policy" {
  statement {
    sid    = "AWSBudgetsSNSPublishingPermissions"
    effect = "Allow"

    actions = [
      "SNS:Receive",
      "SNS:Publish"
    ]

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.aws-sns-topic.arn
    ]
  }
}

data "aws_iam_policy_document" "aws-anomaly-policy" {
  statement {
    sid    = "AWSAnomalyDetectionSNSPublishingPermissions"
    effect = "Allow"

    actions = [
      "SNS:Receive",
      "SNS:Publish"
    ]

    principals {
      type        = "Service"
      identifiers = ["costalerts.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.aws-sns-topic.arn
    ]
  }
}


data "aws_iam_policy_document" "aws-all-policy" {
  statement {
    sid    = "AWSBudgetsSNSPublishingPermissions"
    effect = "Allow"

    actions = [
      "SNS:Receive",
      "SNS:Publish"
    ]

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.aws-sns-topic.arn
    ]
  }

  statement {
    sid    = "AWSAnomalyDetectionSNSPublishingPermissions"
    effect = "Allow"

    actions = [
      "SNS:Receive",
      "SNS:Publish"
    ]

    principals {
      type        = "Service"
      identifiers = ["costalerts.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.aws-sns-topic.arn
    ]
  }
}