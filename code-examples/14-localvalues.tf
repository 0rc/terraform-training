# Ids for multiple sets of EC2 instances, merged together
locals {
  instance_ids = "${concat(aws_instance.blue.*.id, aws_instance.green.*.id)}"
}

# A computed default name prefix
locals {
  default_name_prefix = "${var.project_name}-web"
  name_prefix         = "${var.name_prefix != "" ? var.name_prefix : local.default_name_prefix}"
}

# Local values can be interpolated elsewhere using the "local." prefix.
resource "aws_s3_bucket" "files" {
  bucket = "${local.name_prefix}-files"

  # ...
}
