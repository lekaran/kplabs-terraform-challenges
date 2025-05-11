resource "aws_iam_user" "users" {
  count = length(var.list_users)

  name = "${var.list_users[count.index]}-user-${data.aws_caller_identity.account.account_id}"
}