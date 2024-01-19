resource "aws_subnet" "subnet" {
  vpc_id     = var.vpcId
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "Subnet"
  }
}
