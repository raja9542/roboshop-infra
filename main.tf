module "network" {
  source = "github.com/raja9542/tf-module-vpc.git"

  for_each = var.vpc
  cidr_block = each.value.cidr_block
}
