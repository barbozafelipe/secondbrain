variable "subscription_list" {
  type = list(string)
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