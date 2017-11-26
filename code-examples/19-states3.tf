data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket         = "terraform-state-prod"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-lock-table"
  }
}
