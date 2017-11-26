module "consul" {
  source  = "hashicorp/consul/aws"
  servers = 5
  version = ">= 1.0.0, <= 2.0.0"
}
