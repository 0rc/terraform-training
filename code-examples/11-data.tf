data "aws_ami" "web" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Component"
    values = ["web"]
  }

  most_recent = true
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.web.id}"
  instance_type = "t1.micro"
}
