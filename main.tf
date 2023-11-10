module "network" {
  source = "github.com/raja9542/tf-module-vpc.git"
  env = var.env
  default_vpc_id = var.default_vpc_id
  for_each = var.vpc
  cidr_block = each.value.cidr_block
}
