module "network" {
  source = "github.com/raja9542/tf-module-vpc.git"
  env = var.env
  default_vpc_id = var.default_vpc_id
  for_each = var.vpc
  cidr_block = each.value.cidr_block
  public_subnets_cidr = each.value.public_subnets_cidr
  private_subnets_cidr = each.value.private_subnets_cidr
  availability_zones = each.value.availability_zones
}
