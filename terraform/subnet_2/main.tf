resource "aws_subnet" "subnet_2" {
  vpc_id     = var.vpcId_2
  cidr_block = var.subnet_cidr_2
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subnet-2"
  }
}
