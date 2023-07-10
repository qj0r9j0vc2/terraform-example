resource "aws_kinesis_stream" "example-kds" {
  name             = "example-kds"
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Environment = "example"
  }
}
