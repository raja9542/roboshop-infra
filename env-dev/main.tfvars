env = "dev"
default_vpc_id = "vpc-0e9be6cf7a7cbd838"

vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    subnets_cidr = ["10.0.0.0/17", "10.0.128.0/17"]
  }
}