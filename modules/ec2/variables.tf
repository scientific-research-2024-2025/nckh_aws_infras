variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
}

variable "instance_key" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}
