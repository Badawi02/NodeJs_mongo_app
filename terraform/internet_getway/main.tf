resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpcID
  tags = {
    Name = var.Name_IGW
  }
}