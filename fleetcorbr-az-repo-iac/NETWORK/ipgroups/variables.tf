variable "ip_groups" {
  type = map(object({
    cidrs = list(string)
  }))
}
