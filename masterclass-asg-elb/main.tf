######
# Launch configuration
######
module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "1.2.0"

  key_name                  = "batiyevsky-keypair"
  user_data                 = "${data.template_file.user_data.rendered}"
  health_check_grace_period = 120
  min_elb_capacity          = 1

  lc_name = "example-lc"

  image_id          = "${data.aws_ami.amazon_linux.id}"
  instance_type     = "t2.micro"
  security_groups   = ["${data.aws_security_group.default.id}"]
  load_balancers    = ["${module.elb.this_elb_id}"]
  target_group_arns = []

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "8"
      volume_type = "gp2"
    },
  ]

  ######
  # Autoscaling group 
  ######

  asg_name                  = "example-asg"
  vpc_zone_identifier       = ["${data.aws_subnet_ids.all.ids}"]
  health_check_type         = "ELB"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
  ]
}

######
# ELB
######
module "elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "elb-example"

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
