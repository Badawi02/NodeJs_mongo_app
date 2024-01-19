# =================== vpc module =====================
module "vpc" {
    source = "./vpc"
    cidr_block_vpc = "10.0.0.0/16"
    Name_vpv = "main_vpc"
}

# =================== IGW module =====================
module "internet_getway" {
    source = "./internet_getway"
    Name_IGW = "IGW"
    vpcID = module.vpc.vpc-id
}

# =================== route table module =====================
module "route-table-public" {
  source = "./route-table-public"
  vpcID = module.vpc.vpc-id
  gwID = module.internet_getway.IGW
  Name_route_table = "route-table-public"
  subnetID = module.subnet.subnet_id
  subnetID_2 = module.subnet_2.subnet_2_id
  cidr_block_route_table = "0.0.0.0/0"
}

# =================== first subnet module =====================
module "subnet" {
    source = "./subnet"
    vpcId = module.vpc.vpc-id
    subnet_cidr = "10.0.0.0/24"
}

# =================== sec subnet module =====================
module "subnet_2" {
    source = "./subnet_2"
    vpcId_2 = module.vpc.vpc-id
    subnet_cidr_2 = "10.0.1.0/24"
}

# =================== EC2 module =====================
module "ec2_public" {
  source = "./ec2-public"
  instance_type = "t2.medium"
  associate_public_ip_address = "true"
  subnetID = module.subnet.subnet_id
  secGroupId = [module.security_group_public.security_group_id]
  public_ec2 = "public_ec2"
  userData = file("userData.tpl")
}

# =================== security group module =====================
module "security_group_public" {
    source = "./security-group-public"
    Name_security_group = "security_group"
    Ports_security_group = [ 22 , 0 , 8080 ]
    Protocol_security_group = ["tcp" , "-1"] 
    cidr_security_group = "0.0.0.0/0"
    vpcID = module.vpc.vpc-id
}
