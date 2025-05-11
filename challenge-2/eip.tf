resource "aws_eip" "example" {
  #  domain = "vpc"
  vpc = true
}