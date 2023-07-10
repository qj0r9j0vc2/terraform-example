output "connect" {
  value = "ssh ubuntu@${aws_instance.example-ec2.public_ip}"
}
