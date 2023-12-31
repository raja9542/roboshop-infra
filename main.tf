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
  number_of_instances    = each.value.number_of_instances
  instance_class         = each.value.instance_class
}

module "rds" {
  source = "github.com/raja9542/tf-module-rds.git"
  env                    = var.env
  for_each               = var.rds
  #  db private subnet id value from module vpc we need to get
  subnet_ids             = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnet_ids", null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id                 = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr             = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  // we need app cidrs only  from var.vpc so we are givinp app
  engine                 = each.value.engine
  engine_version         = each.value.engine_version
  number_of_instances    = each.value.number_of_instances
  instance_class         = each.value.instance_class
}

module "elasticache" {
  source = "github.com/raja9542/tf-module-elasticache.git"
  env                    = var.env
  for_each               = var.elasticache
  #  db private subnet id value from module vpc we need to get
  subnet_ids             = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnet_ids", null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id                 = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr             = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  // we need app cidrs only  from var.vpc so we are givinp app
  num_cache_nodes        = each.value.num_cache_nodes
  node_type              = each.value.node_type
  engine_version         = each.value.engine_version
}

module "rabbitmq" {
  source = "github.com/raja9542/tf-module-rabbitmq.git"
  env                    = var.env
  bastion_cidr           = var.bastion_cidr
  for_each               = var.rabbitmq
  #  db private subnet id value from module vpc we need to get
  subnet_ids             = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnet_ids", null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id                 = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr             = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  // we need app cidrs only  from var.vpc so we are givinp app
}

module "alb" {
  source = "github.com/raja9542/tf-module-alb.git"
  env                    = var.env
  for_each               = var.alb
  subnet_ids             = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id                 = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr             = each.value.internal ? concat(lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "web", null), "cidr_block", null), lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)) : ["0.0.0.0/0"]
  subnets_name           = each.value.subnets_name
  internal               = each.value.internal
  dns_domain             = each.value.dns_domain
}

#module "apps" {
#  source = "github.com/raja9542/tf-module-app.git"
#  env                      = var.env
#
#  depends_on               = [module.docdb, module.rds, module.rabbitmq, module.elasticache, module.alb]
#  for_each                 = var.apps
#  subnet_ids               = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_ids", null)
#  vpc_id                   = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
#  allow_cidr               = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), each.value.allow_cidr_subnets_type, null), each.value.allow_cidr_subnets_name, null), "cidr_block", null)
#  alb                      = lookup(lookup(module.alb, each.value.alb, null ), "dns_name", null)
#  listener                 = lookup(lookup(module.alb, each.value.alb, null ), "listener", null)
#  alb_arn                  = lookup(lookup(module.alb, each.value.alb, null ), "alb_arn", null)
#  component                = each.value.component
#  app_port                 = each.value.app_port
#  max_size                 = each.value.max_size
#  min_size                 = each.value.min_size
#  desired_capacity         = each.value.desired_capacity
#  instance_type            = each.value.instance_type
#  listener_priority        = each.value.listener_priority
#  bastion_cidr             = var.bastion_cidr
#  monitor_cidr             = var.monitor_cidr
#}


// Load Test Machine
#resource "aws_spot_instance_request" "load" {
#  instance_type          = "t3.medium"
#  ami                    = "ami-03265a0778a880afb"
#  subnet_id              = "subnet-0942c764e02b89f5f"
#  vpc_security_group_ids = ["sg-02a55f2a99bb97993"]
#  wait_for_fulfillment   = true
#}
#
#resource "aws_ec2_tag" "tag" {
#  resource_id = aws_spot_instance_request.load.spot_instance_id
#  key         = "Name"
#  value       = "load-runner"
#}
#
#resource "null_resource" "apply" {
#  provisioner "remote-exec" {
#    connection {
#      host     = aws_spot_instance_request.load.public_ip
#      user     = "root"
#      password = "DevOps321"
#    }
#    inline = [
#      "curl -s -L https://get.docker.com | bash",
#      "systemctl enable docker",
#      "systemctl start docker",
#      "docker pull robotshop/rs-load"
#    ]
#  }
#}

module "minikube" {
  source = "github.com/scholzj/terraform-aws-minikube"

  aws_region        = "us-east-1"
  cluster_name      = "minikube"
  aws_instance_type = "t3.medium"
  ssh_public_key    = "~/.ssh/id_rsa.pub"
  # element function to pic 0 index value in list ..we need 1 public subnet id
  aws_subnet_id     = element(lookup(lookup(lookup(lookup(module.vpc, "main", null), "public_subnet_ids", null), "public", null), "subnet_ids", null), 0)
  //ami_image_id        = data.aws_ami.ami.id
  hosted_zone         = var.hosted_zone
  hosted_zone_private = false

  tags = {
    Application = "Minikube"
  }

  addons = [
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/storage-class.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/heapster.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/dashboard.yaml",
    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/external-dns.yaml"
  ]
}

output "MINIKUBE_SERVER" {
  value = "ssh centos@${module.minikube.public_ip}"
}

output "KUBE_CONFIG" {
  value = "scp centos@${module.minikube.public_ip}:/home/centos/kubeconfig ~/.kube/config"
}

# 1. output "redis" {
#value = module.elasticache
#}
 # result:

#redis = {
#  "main" = {
#    "redis" = {
#      "apply_immediately" = tobool(null)
#      "arn" = "arn:aws:elasticache:us-east-1:994733300076:cluster:dev-elasticache"
#      "auto_minor_version_upgrade" = "true"
#      "availability_zone" = "us-east-1a"
#      "az_mode" = "single-az"
#      "cache_nodes" = tolist([
#        {
#          "address" = "dev-elasticache.ea5ont.0001.use1.cache.amazonaws.com"
#          "availability_zone" = "us-east-1a"
#          "id" = "0001"
#          "outpost_arn" = ""
#          "port" = 6379
#        },
#      ])
#      "cluster_address" = tostring(null)
#      "cluster_id" = "dev-elasticache"
#      "configuration_endpoint" = tostring(null)


// for each.value.subnet_type we are referring the output values from vpc module.. so the names in main.tfvars should be according to that(public_subnet_ids,private_subnte_ids)
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

