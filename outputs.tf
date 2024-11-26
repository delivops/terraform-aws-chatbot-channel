output "sns_topic_arn" {
  value       = aws_sns_topic.aws-sns-topic.arn
  description = "The ARN of the AWS SNS topic."
}
