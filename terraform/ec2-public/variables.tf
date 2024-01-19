# vars of public ec2
variable "instance_type" {
  type = string
}
variable "associate_public_ip_address" {
  type = string
}
variable "subnetID" {
  type = string
}
variable "secGroupId" {
  type = list
}
variable "public_ec2" {
  type = string
}
variable "userData" {
  type = string
}
