variable "list_users" {
  description = "This is the list of users that we want create AWS IAM"
  type        = list(string)
  default     = ["admin", "dev", "infra"]
}