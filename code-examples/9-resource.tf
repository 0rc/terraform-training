resource "aws_instance" "web" {
  ami           = "ami-408c7f28"
  instance_type = "t1.micro"
  count         = 1
  depends_on    = ["aws_instance.database", "module.vpc"]
  provider      = "aws.west"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = ["user_data", "ebs_block_device"]
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }
}
