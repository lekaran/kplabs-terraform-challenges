variable "splunk" {
  default = "8088"
}

variable "sg_name" {
  description = "The name of the SG"
  type        = string
  default     = "payment_app"
}

variable "https_port" {
  description = "The HTTPS port"
  type        = number
  default     = 443
}

variable "dev_api_port" {
  description = "The API port from DEV VPC"
  type        = number
  default     = 8080
}

variable "prod_api_port" {
  description = "The API prot from PROD VPC"
  type        = number
  default     = 8443
}