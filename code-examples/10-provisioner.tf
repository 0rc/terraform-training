resource "aws_instance" "web" {
  ami           = "ami-408c7f28"
  instance_type = "t1.micro"

  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"

    connection {
      type     = "ssh"
      user     = "root"
      password = "${var.root_password}"
    }
  }
}
