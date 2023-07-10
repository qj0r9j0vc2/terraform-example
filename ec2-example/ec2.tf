resource "aws_key_pair" "example-key" {
  key_name   = "example-key"
  public_key = file(var.private_key_path)
}

resource "aws_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
}
resource "aws_security_group" "example-sg-22" {
  name        = "example-sg-22"
  description = "Allow 22 port"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "TCP"
    self        = false
    to_port     = 22
  }

  tags = {
    "Name" = "exampmle-sg-22"
  }
}


resource "aws_instance" "example-ec2" {
  depends_on = [aws_default_vpc.default]

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.example-sg-22.id,
    aws_security_group.default.id
  ]

  key_name                    = aws_key_pair.example-key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "example-ec2"
  }
}
