variable "resource_group_name" {
  type = string
}

variable "subscription_id" {
  type        = list(string)
  description = "Id da subscription onde serão configurados os activity logs"
}

variable "activity_log_alert" {
  type = list(object({
    name        = string
    description = string
    criteria = list(object({
      operation_name = string
      category       = string
    }))
  }))
}