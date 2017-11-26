locals {
  name_prefix = "testapp-${var.env_name}"
}

######
# Launch config
######
resource "aws_launch_configuration" "testapp" {
  name_prefix     = "${local.name_prefix}"
  depends_on      = ["module.db"]
  image_id        = "${data.aws_ami.amazon_linux.id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${data.aws_security_group.default.id}"]
  key_name        = "batiyevsky-keypair"

  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

######
# Autoscaling group
######
resource "aws_autoscaling_group" "testapp" {
  name                 = "${local.name_prefix} - ${aws_launch_configuration.testapp.name}"
  depends_on           = ["module.db"]
  min_size             = "${var.asg_min_size}"
  max_size             = "${var.asg_max_size}"
  min_elb_capacity     = "${var.asg_min_size}"
  launch_configuration = "${aws_launch_configuration.testapp.id}"
  health_check_type    = "ELB"
  load_balancers       = ["${module.elb.this_elb_id}"]
  termination_policies = ["OldestLaunchConfiguration"]
  vpc_zone_identifier  = ["${data.aws_subnet_ids.all.ids}"]

  lifecycle {
    create_before_destroy = true
  }
}

######
# ELB
######
module "elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "${local.name_prefix}-elb"

  subnets         = ["${data.aws_subnet_ids.all.ids}"]
  security_groups = ["${data.aws_security_group.default.id}"]
  internal        = false

  listener = [
    {
      instance_port     = "3000"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = [
    {
      target              = "HTTP:3000/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

######
# RDS
######
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${local.name_prefix}-db"

  engine            = "postgres"
  engine_version    = "9.6.3"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  name = "${var.db_name}"

  username = "${var.db_user}"

  password = "${var.db_pass}"
  port     = "5432"

  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  subnet_ids = ["${data.aws_subnet_ids.all.ids}"]

  family = "postgres9.6"

  final_snapshot_identifier = "${local.name_prefix}-db"
}
