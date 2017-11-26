resource "aws_instance" "web" {
  provisioner "chef" {
    attributes_json = <<-EOF
      {
        "key": "value",
        "app": {
          "cluster1": {
          	"webserver1"
          }
        }
      }
    EOF

    environment     = "_default"
    run_list        = ["cookbook::recipe"]
    node_name       = "webserver1"
    secret_key      = "${file("../encrypted_data_bag_secret")}"
    server_url      = "https://chef.company.com/organizations/org1"
    recreate_client = true
    user_name       = "bork"
    user_key        = "${file("../bork.pem")}"
    version         = "12.4.1"

    ssl_verify_mode = ":verify_none"
  }
}
