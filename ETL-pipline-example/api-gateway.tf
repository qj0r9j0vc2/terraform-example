module "kinesis_api_gateway" {
  source = "dod-iac/kinesis-api-gateway/aws"

  allow_describe_stream  = false
  allow_get_records = true
  allow_list_shards  = false
  allow_list_streams  = false
  allow_put_record = true
  allow_put_records = false

  authorization       = "NONE"
  execution_role_name = "api-%s-%s-example"
  name                = "api-%s-%s-example"
  streams             = [aws_kinesis_stream.example-kds.arn]

  tags = {
    Environment = "example"
    Automation  = "Terraform"
  }
}
