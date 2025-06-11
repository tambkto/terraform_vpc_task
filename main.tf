module "vpc" {
  source = "./vpc"
  vpc_cidr = var.vpc-cidr
  cidr_allowing_all = var.cidr-allowing-all
  public_subnet_cidr = var.public-subnet-cidr
  owner_name = "Umar"
  providers = {
    aws = aws.ohio
  }
}
module "ec2" {
  source = "./ec2"
  vpcid = module.vpc.vpc_id
  owner_name = "Umar"
  aws-subnet = module.vpc.aws_subnet
  instance_ami = var.instance-ami
  ingress_cidr = var.ingress-cidr
  cidr_allowing_all = var.cidr-allowing-all
  instance_type = var.instance-type
  providers = {
    aws = aws.ohio
  }
}

