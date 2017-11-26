data "template_file" "user_data" {
  template = "${file("user_data.tpl")}"

  vars {
    env              = "${var.environment_name}"
    env-number       = "${var.environment_number}"
    project          = "${var.project_name}"
    dns_domain       = "${var.environment_name == "pro" ? "pro.aws" : "test.aws"}"
    dns_cloud_domain = "${var.environment_name == "pro" ? "cloud.com" : "cloud-test.com"}"
  }
}
