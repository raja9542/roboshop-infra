module "vpc" {
  source                 = "github.com/raja9542/tf-module-vpc.git"
  env                    = var.env
  default_vpc_id         = var.default_vpc_id
  for_each               = var.vpc
  cidr_block             = each.value.cidr_block
  subnets                = each.value.subnets
  availability_zone      = each.value.availability_zone
    }

#module "subnets" {
#  source = "github.com/raja9542/tf-module-subnets.git"
#  env = var.env
#  default_vpc_id = var.default_vpc_id
#
#  for_each                  = var.subnets
#  cidr_block                = each.value.cidr_block
#  availability_zone         =each.value.availability_zone
#  name                      = each.value.name
#  # to get output of map of map variable and from another module use lookup function
#  vpc_id                    = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
#  vpc_peering_connection_id  = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_peering_connection_id", null)
#  # look for each.value for internet_gw if it is there it will give true if not default value false
#  internet_gw                = lookup(each.value, "internet_gw", false )
#  nat_gw                     = lookup(each.value, "nat_gw", false )
#
#}

output "subnet_ids" {
  value = module.subnets
}
# 1 output for this
#output "subnet_ids" {
#  value = module.subnets
#}
#   lookup(lookup(module.subnets, "public", null), "subnet_ids", null)
#subnet_ids = {
#  "app" = {
#    "subnet_ids" = [
#      "subnet-0c6dd8bf45b36d216",
#      "subnet-0a72e38d6e2b18f7e",
#    ]
#  }
#  "db" = {
#    "subnet_ids" = [
#      "subnet-0b34b113781e86641",
#      "subnet-0b45282ab5ff2d7b4",
#    ]
#  }
#  "public" = {
#    "subnet_ids" = [
#      "subnet-0be6e8dbe2b447bcb",
#      "subnet-0c078c8d86477dcf8",
#    ]
#  }
#  "web" = {
#    "subnet_ids" = [
#      "subnet-0890e8bfb865e2f9a",
#      "subnet-06f9d14abc54865f2",
#    ]
#  }
#}

#2output for this

#output "vpc_id" {
#value = lookup(module.vpc, "main", null)
#}
#vpc_id = {
#  "vpc_id" = "vpc-0e0952dda633abb33"
#}

#3output for this

#output "vpc_id" {
#  value = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
#}
#"vpc-0e0952dda633abb33"

