data "template_file" "example" {
  template = "$${hello} $${world}!"
  vars {
    hello = "goodnight"
    world = "moon"
  }
}

output "rendered" {
  value = "${data.template_file.example.rendered}"
}
