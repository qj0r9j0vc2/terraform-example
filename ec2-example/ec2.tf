resource "aws_key_pair" "example-key" {
  key_name   = "example-key-pair"
  public_key = file("~/.ssh/id_rsa.pub") # replace with the path to your public key file
}

resource "aws_instance" "example-ec2" {
  ami = "ami-0c6e5afdd23291f73" # Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2023-03-28
  instance_type = "t3.medium"
  subnet_id = aws_subnet.example-subnet-publicA.id
  security_groups = [
    aws_security_group.example-sg-ssh.id,
    aws_default_security_group.default.id
  ]
  key_name = "example-key-pair"
  associate_public_ip_address = true

  tags = {
    Name = "example-ec2"
  }
}
