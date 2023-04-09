resource "aws_ecr_repository" "example-ecr-repository" {
  name                 = "example-ecr-private"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.example-ecr-repository.repository_url
}

resource "null_resource" "null_for_ecr_get_login_password" {
  provisioner "local-exec" {
    command = <<EOF
    docker pull bitnami/nginx:latest;
    docker tag bitnami/nginx:latest ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${aws_ecr_repository.example-ecr-repository.name}:latest;
    aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${aws_ecr_repository.example-ecr-repository.repository_url};
    docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${aws_ecr_repository.example-ecr-repository.name}:latest
    EOF
  }
}

