variable "instance_type" {
  description = "Defines instance type"
  default     = "t3.micro"
}

variable "public_key_path" {
  description = "Defines public key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami_name" {
  description = "EC2 instance images"
  default     = "ubuntu/images/hvm-ssd/*" //If you want to use Amazon Linxu 2, you can take as "amzn2-ami-hvm*"
}
