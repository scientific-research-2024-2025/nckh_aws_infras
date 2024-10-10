# Values ​​of variables are stored in .tfvars
data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "./modules/vpc"
  aws_azs = data.aws_availability_zones.available.names[0]
}

module "ssh_key" {
  source          = "./modules/key_pair"
  key_name        = var.key_name
  public_key_path = var.public_key_path
}

module "ec2_instance" {
  depends_on      = [module.vpc]
  source          = "./modules/ec2"
  instance_key    = module.ssh_key.public_key_name
  instance_type   = "t2.micro"
  security_groups = [module.vpc.sg_name]
  subnet_id       = module.vpc.public_subnet_id
}
