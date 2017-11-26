resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command     = "echo ${aws_instance.web.private_ip} >> private_ips.txt"
    interpreter = ["/bin/bash", "-x"]
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
