resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command    = "echo ${self.private_ip} > file.txt"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command = "echo second"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sudo rm -rf /"
  }
}
