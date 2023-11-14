env = "dev"
default_vpc_id = "vpc-0e9be6cf7a7cbd838"

vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    availability_zone = ["us-east-1a", "us-east-1b"]
      public_subnets = {
          public = {

            name              = "public"
            cidr_block        = ["10.0.0.0/24", "10.0.1.0/24"]
            internet_gw       = true

          }
      }
      private_subnets = {
        web = {

          name              = "web"
          cidr_block        = ["10.0.2.0/24", "10.0.3.0/24"]
          nat_gw            = true

        }

        app = {

          name              = "app"
          cidr_block        = ["10.0.4.0/24", "10.0.5.0/24"]
          nat_gw            = true

        }

        db = {

          name              = "db"
          cidr_block        = ["10.0.6.0/24", "10.0.7.0/24"]
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
    engine_version       = "5.7.mysql_aurora.2.12.0.1"
    number_of_instances  = 1
    instance_class       = "db.t3.medium"

  }
}

elasticache = {
  main = {
    vpc_name             = "main"
    subnets_name         = "db"
    num_node_groups         = 2
    replicas_per_node_group = 1
    node_type            = "cache.t3.micro"

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

  }

  private = {
    vpc_name             = "main"
    subnets_type         = "private_subnet_ids"
    subnets_name         = "app"
    internal             = true

  }
}
# An internal load balancer routes requests from clients to targets using private IP addresses. if internal true it is internal load balancer
# if internal false it is Internet-facing
# An internet-facing load balancer routes requests from clients over the internet to targets. Requires a public subnet.