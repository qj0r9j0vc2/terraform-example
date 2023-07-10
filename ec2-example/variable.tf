variable "instance_type" {
  description = "Defines instance type"
  default     = "t3.micro"
}

variable "private_key_path" {
  description = "Defines private key path"
  default     = "~/.ssh/id_rsa.pub"
}
