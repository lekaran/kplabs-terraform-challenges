output "users" {
  description = "All users created"
  value = var.list_users
}

output "total_user" {
  description = "The number of users"
  value = length(var.list_users)
}