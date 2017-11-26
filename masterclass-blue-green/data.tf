data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "tmp-ssh"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

data "template_file" "user_data" {
  template = "${file("user-data.tpl")}"

  vars {
    app_version = "${var.app_version}"
    db_user     = "${var.db_user}"
    db_pass     = "${var.db_pass}"
    db_host     = "${module.db.this_db_instance_address}"
    db_name     = "${var.db_name}"
  }
}
