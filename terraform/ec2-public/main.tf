data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]
}

resource "aws_instance" "instance" {
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu.image_id
  subnet_id     = var.subnetID
  key_name      = aws_key_pair.key_pair.key_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data = var.userData
  tags = {
    Name = var.public_ec2
  }
  vpc_security_group_ids = var.secGroupId
}


# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "ec2_key"
  public_key = tls_private_key.key_pair.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}