resource "aws_route_table" "route-table" {
  vpc_id = var.vpcID

  route {
    cidr_block      = var.cidr_block_route_table
    gateway_id = var.gwID
  }

  tags = {
    Name = var.Name_route_table
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = var.subnetID
  route_table_id = aws_route_table.route-table.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = var.subnetID_2
  route_table_id = aws_route_table.route-table.id
}