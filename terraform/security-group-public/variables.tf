
# vars of security group 1
variable "Name_security_group" {
  type = string
}
variable "Ports_security_group" {
  type = list
}
variable "Protocol_security_group" {
  type = list
}
variable "cidr_security_group" {
  type = string
}

variable "vpcID" {
  type = string
}