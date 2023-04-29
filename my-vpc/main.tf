 module "my_vpc" {
  source = "../my-vpc-module"

  vpc_cidr_block          = "10.0.0.0/16"
  public_subnet_cidr_block = "10.0.1.0/24"
  private_subnet_cidr_block = "10.0.2.0/24"
  region                  = "us-west-2"
  instance_type           = "t2.micro"
}  