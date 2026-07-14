locals {
  # SNS topic names and Chatbot configuration_name only allow [A-Za-z0-9_-] and
  # have a max length (SNS 256, Chatbot config 128). The channel name may contain
  # disallowed characters, so collapse every run of invalid chars into a single
  # hyphen and cap the combined name at 128 (the tighter Chatbot limit).
  resource_name = substr(
    replace(
      lower("${coalesce(var.name_prefix, var.chatbot_workspace_id)}-${var.slack_channel_name}"),
      "/[^a-z0-9_-]+/",
      "-",
    ),
    0,
    128,
  )
}

resource "aws_sns_topic" "aws-sns-topic" {
  name = local.resource_name
}

resource "aws_sns_topic_policy" "aws-sns-topic-policy" {
  count  = var.alert_type == "budget" ? 1 : 0
  arn    = aws_sns_topic.aws-sns-topic.arn
  policy = data.aws_iam_policy_document.aws-budget-policy.json
}
resource "aws_sns_topic_policy" "aws-sns-topic-anomaly-policy" {
  count  = var.alert_type == "cost-anomalies" ? 1 : 0
  arn    = aws_sns_topic.aws-sns-topic.arn
  policy = data.aws_iam_policy_document.aws-anomaly-policy.json
}
resource "aws_sns_topic_policy" "aws-sns-topic-all-policy" {
  count  = var.alert_type == "all" ? 1 : 0
  arn    = aws_sns_topic.aws-sns-topic.arn
  policy = data.aws_iam_policy_document.aws-all-policy.json
}
resource "aws_chatbot_slack_channel_configuration" "aws-slack-channel" {
  configuration_name    = local.resource_name
  iam_role_arn          = var.chatbot_role_arn
  slack_channel_id      = var.slack_channel_id
  slack_team_id         = var.chatbot_workspace_id
  sns_topic_arns        = [aws_sns_topic.aws-sns-topic.arn]
  guardrail_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
