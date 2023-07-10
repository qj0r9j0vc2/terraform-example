
# EC2-example
---
 simpel terraform script for EC2.

 It creates a VPC and EC2 instance with only a public subnet.
 
 You can add your private EC2 on private subnets and use public EC2 as bastion server

![EC2](https://user-images.githubusercontent.com/59428479/232494715-df8a6cb8-5f12-405f-9bb0-846453489d0b.png)


# How to get started

## main.tf
```
provider "aws" {
  access_key = "XXXXXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  region     = "ap-northeast-2"
}

module "ec2" {
  source = "github.com/qj0r9j0vc2/terraform-example/ec2-module"
  //instance_type = "t3.large"
  //public_key_path = "~/Desktop/test.pub"
  //ami_name = "amzn2-ami-hvm*"
}

```