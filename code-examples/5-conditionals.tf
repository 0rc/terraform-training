resource "aws_instance" "web" {
  subnet = "${var.env == "production" ? var.prod_subnet : var.dev_subnet}"
}

resource "aws_instance" "vpn" {
  count = "${var.something ? 1 : 0}"
}
