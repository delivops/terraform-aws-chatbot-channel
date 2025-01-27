resource "aws_sns_topic" "aws-sns-topic" {
  name = var.slack_channel_name
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
  configuration_name    = "${var.chatbot_workspace_name}-${var.slack_channel_name}"
  iam_role_arn          = var.chatbot_role_arn
  slack_channel_id      = var.slack_channel_id
  slack_team_id         = data.aws_chatbot_slack_workspace.workspace.slack_team_id
  sns_topic_arns        = [aws_sns_topic.aws-sns-topic.arn]
  guardrail_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
