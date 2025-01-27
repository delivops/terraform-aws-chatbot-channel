variable "alert_type" {
  type        = string
  description = "Type of alert to configure: 'budget', 'cost-anomalies', 'cloudwatch-alarms', or 'all'"
  validation {
    condition     = contains(["budget", "cost-anomalies", "all", "cloudwatch-alarms"], var.alert_type)
    error_message = "alert_type must be one of: budget, cost-anomalies, cloudwatch-alarms, or all"
  }
}
variable "slack_channel_name" {
  type        = string
  description = "slack channel name"
}
variable "slack_channel_id" {
  type        = string
  description = "slack channel id"

}
variable "chatbot_role_arn" {
  type        = string
  description = "chatbot role arn"

}
variable "chatbot_workspace_name" {
  type        = string
  description = "workspace"
}
