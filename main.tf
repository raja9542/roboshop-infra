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

  for_each                  = var.subnets
  cidr_block                = each.value.cidr_block
  availability_zone         =each.value.availability_zone
  name                      = each.value.name
  # to get output of map of map variable and from another module use lookup function
  vpc_id                    = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  vpc_peering_connection_id  = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_peering_connection_id", null)
  internet_gw_id             = lookup(lookup(module.vpc, each.value.vpc_name, null), "internet_gw_id", null)
  # look for each.value for internet_gw if it is there it will give true if not default value false
  internet_gw                = lookup(each.value, "internet_gw", false )
  nat_gw                     = lookup(each.value, "nat_gw", false )

}

output "subnet_ids" {
  value = module.subnets
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

