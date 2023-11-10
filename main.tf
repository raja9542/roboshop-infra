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

  for_each = var.subnets
  cidr_block = each.value.cidr_block
  availability_zone =each.value.availability_zone
  name = each.value.name
  vpc_id = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null) # to get output of map of map variable use lookup function
  vpc_peering_connection_id = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_peering_connection_id", null)

}


#output for this

#output "vpc_id" {
#value = lookup(module.vpc, "main", null)
#}
#vpc_id = {
#  "vpc_id" = "vpc-0e0952dda633abb33"
#}

#output for this

#output "vpc_id" {
#  value = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
#}
#"vpc-0e0952dda633abb33"

