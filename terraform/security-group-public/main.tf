resource "aws_security_group" "allow_tls" {
  name        = var.Name_security_group
  vpc_id      = var.vpcID

  ingress {
    from_port        = var.Ports_security_group[0]
    to_port          = var.Ports_security_group[0]
    protocol         = var.Protocol_security_group[0]
    cidr_blocks      = [ var.cidr_security_group ]
  }

  ingress {
    from_port        = var.Ports_security_group[2]
    to_port          = var.Ports_security_group[2]
    protocol         = var.Protocol_security_group[0]
    cidr_blocks      = [ var.cidr_security_group ]
  }

  egress {
    from_port        = var.Ports_security_group[1]
    to_port          = var.Ports_security_group[1]
    protocol         = var.Protocol_security_group[1]
    cidr_blocks      = [ var.cidr_security_group ]
  }

}