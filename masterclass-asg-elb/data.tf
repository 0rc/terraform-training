data "template_file" "user_data" {
  template = "${file("user-data.tpl")}"

  vars {
    app_version = "0.1"
    db_user     = ""
    db_pass     = ""
    db_host     = ""
    db_name     = ""
  }
}
