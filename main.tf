module "vpc" {
  source                 = "github.com/raja9542/tf-module-vpc.git"
  env                    = var.env
  default_vpc_id         = var.default_vpc_id
  for_each               = var.vpc
  cidr_block             = each.value.cidr_block
  public_subnets         = each.value.public_subnets
  private_subnets         = each.value.private_subnets
  availability_zone      = each.value.availability_zone
    }

output "out" {
  value = module.vpc
}

module "docdb" {
  source = "github.com/raja9542/tf-module-docdb.git"
  env                    = var.env
  for_each               = var.docdb
#  db private subnet id value from module vpc we need to get
  subnet_ids             = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnet_ids", null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id                 = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr             = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  // we need app cidrs only  from var.vpc so we are givinp app
  engine_version         = each.value.engine_version
}


// for vpc_id we need look in module vpc in that main map we have vpc_id as shown below
//  .... lookup(lookup(lookup(lookup(module.vpc, "main", null), "private_subnet_ids", null), "db", null), "subnet_ids", null) or
// lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnet_ids", null), each.value.subnets_name, null), "subnet_ids", null)
// 1.output "private_subnet_ids" {
//  value = module.private_subnets
//}
#    out = {
#      "main" = {
#        "private_subnet_ids" = {
#          "app" = {
#            "subnet_ids" = [
#              "subnet-080452a292443a09f",
#              "subnet-0e308cabf906cdeef",
#            ]
#          }
#          "db" = {
#            "subnet_ids" = [
#              "subnet-0b2d9c660a947d3ef",
#              "subnet-09b2aa79a5546cef2",
#            ]
#          }
#          "web" = {
#            "subnet_ids" = [
#              "subnet-034d11058070bd810",
#              "subnet-0bdb82984c8117ee2",
#            ]
#          }
#        }
#        "public_subnet_ids" = {
#          "public" = {
#            "subnet_ids" = [
#              "subnet-04013c99c9a9742f8",
#              "subnet-06a34436a5ae79572",
#            ]
#          }
#        }
#        "vpc_id" = "vpc-0c99f8911fedcf229"
#        "vpc_peering_connection_id" = "pcx-0a8878f8fcadfd7e2"
#      }
#    }












#out = {
#  "main" = { -----this is from root module
#    "public_subnet_ids" = { ===from vpc module
#      "public" = { ---from public_subnets module
#        "subnet_ids" = [
#          "subnet-00adbe860e3616783",
#          "subnet-0a473f1120f11aaf8",
#        ]
#      }
#    }
#    "vpc_id" = "vpc-0496ca9654fa61564"
#    "vpc_peering_connection_id" = "pcx-02e186f1ce4a8d3cf"
#  }
#}


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

#output "subnet_ids" {
#  value = module.subnets
#}
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

