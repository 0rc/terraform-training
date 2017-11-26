data "template_file" "user_data" {
  template = "${file("user-data.tpl")}"

  vars {
    app_version = "0.1"
    db_user     = "${module.db.this_db_instance_username}"
    db_pass     = "${module.db.this_db_instance_password}"
    db_host     = "${module.db.this_db_instance_address}"
    db_name     = "${module.db.this_db_instance_name}"
  }
}
