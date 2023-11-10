module "vpc" {
  source = "github.com/raja9542/tf-module-vpc.git"
  env = var.env
  default_vpc_id = var.default_vpc_id
  for_each = var.vpc
  cidr_block = each.value.cidr_block
}

module "subnets" {
  source = "github.com/raja9542/tf-module-subnets.git"
  env = var.env
  default_vpc_id = var.default_vpc_id
  vpc_id = module.vpc.vpc_id
  for_each = var.subnets
  cidr_block = each.value.cidr_block
  availability_zone =each.value.availability_zone
  name = each.value.name
}
