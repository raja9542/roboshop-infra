env            = "prod"
default_vpc_id = "vpc-0e9be6cf7a7cbd838"
bastion_cidr   = ["172.31.94.83/32"]
monitor_cidr   = ["172.31.34.153/32"]
hosted_zone    = "devopsraja66.online"

vpc = {
  main = {
    cidr_block = "10.100.0.0/16"
    availability_zone = ["us-east-1a", "us-east-1b"]
      public_subnets = {
          public = {

            name              = "public"
            cidr_block        = ["10.100.0.0/24", "10.100.1.0/24"]
            internet_gw       = true

          }
      }
      private_subnets = {
        web = {

          name              = "web"
          cidr_block        = ["10.100.2.0/24", "10.100.3.0/24"]
          nat_gw            = true

        }

        app = {

          name              = "app"
          cidr_block        = ["10.100.4.0/24", "10.100.5.0/24"]
          nat_gw            = true

        }

        db = {

          name              = "db"
          cidr_block        = ["10.100.6.0/24", "10.100.7.0/24"]
          nat_gw            = true

        }
      }
  }
}

docdb = {
  main = {
    vpc_name             = "main"
    subnets_name         = "db"
    engine_version       = "4.0.0"
    number_of_instances  = 1
    instance_class       = "db.t3.medium"

  }
}

rds = {
  main = {
    vpc_name             = "main"
    subnets_name         = "db"
    engine               = "aurora-mysql"
    engine_version       = "5.7.mysql_aurora.2.11.3"
    number_of_instances  = 1
    instance_class       = "db.t3.medium"

  }
}

elasticache = {
  main = {
    vpc_name                   = "main"
    subnets_name               = "db"
    engine_version             = "6.x"   # for our app we need 6.3 or 6.x
    num_cache_nodes            = 1
    node_type                  = "cache.t3.micro"

  }
}

rabbitmq = {
  main = {
    vpc_name             = "main"
    subnets_name         = "db"
    engine_type          = "RabbitMQ"
    engine_version       = "3.11.20"
    host_instance_type   = "mq.t3.micro"
    deployment_mode      = "SINGLE_INSTANCE"
  }
}

alb = {

  public= {
    vpc_name             = "main"
    subnets_type         = "public_subnet_ids"
    subnets_name         = "public"
    internal             = false
    dns_domain           = "www"

  }

  private = {
    vpc_name             = "main"
    subnets_type         = "private_subnet_ids"
    subnets_name         = "app"
    internal             = true
    dns_domain           = ""

  }
}
# An internal load balancer routes requests from clients to targets using private IP addresses. if internal true it is internal load balancer
# if internal false it is Internet-facing
# An internet-facing load balancer routes requests from clients over the internet to targets. Requires a public subnet.

apps = {
  frontend = {
    component                = "frontend"
    vpc_name                 = "main"
    subnets_type             = "private_subnet_ids"
    subnets_name             = "web"
    app_port                 = 80
    allow_cidr_subnets_type  = "public_subnets"
    allow_cidr_subnets_name  = "public"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    instance_type             = "t3.micro"
    alb                       = "public"
    listener_priority         = 0

  }
  catalogue = {
    component                = "catalogue"
    vpc_name                 = "main"
    subnets_type             = "private_subnet_ids"
    subnets_name             = "app"
    app_port                 = 8080
    allow_cidr_subnets_type  = "private_subnets"
    allow_cidr_subnets_name  = "app"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    instance_type             = "t3.micro"
    alb                       = "private"
    listener_priority         = 100
  }
  user = {
    component                = "user"
    vpc_name                 = "main"
    subnets_type             = "private_subnet_ids"
    subnets_name             = "app"
    app_port                 = 8080
    allow_cidr_subnets_type  = "private_subnets"
    allow_cidr_subnets_name  = "app"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    instance_type             = "t3.micro"
    alb                       = "private"
    listener_priority         = 101
  }
  cart = {
    component                = "cart"
    vpc_name                 = "main"
    subnets_type             = "private_subnet_ids"
    subnets_name             = "app"
    app_port                 = 8080
    allow_cidr_subnets_type  = "private_subnets"
    allow_cidr_subnets_name  = "app"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    instance_type             = "t3.micro"
    alb                       = "private"
    listener_priority         = 102
  }
  shipping = {
    component                = "shipping"
    vpc_name                 = "main"
    subnets_type             = "private_subnet_ids"
    subnets_name             = "app"
    app_port                 = 8080
    allow_cidr_subnets_type  = "private_subnets"
    allow_cidr_subnets_name  = "app"
    max_size                  = 10
    min_size                  = 3
    desired_capacity          = 3
    instance_type             = "t3.medium"
    alb                       = "private"
    listener_priority         = 103
  }
  payment = {
    component                = "payment"
    vpc_name                 = "main"
    subnets_type             = "private_subnet_ids"
    subnets_name             = "app"
    app_port                 = 8080
    allow_cidr_subnets_type  = "private_subnets"
    allow_cidr_subnets_name  = "app"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    instance_type             = "t3.small"
    alb                       = "private"
    listener_priority         = 104
  }
}