variable "instance_count" {
  type    = number
  default = 1
}

variable "vpc_cidr" {
  type    = string
  default = "10.100.100.0/25"
}

variable "backend_subnet_cidr_1" {
  type    = string
  default = "10.100.100.0/24"
}

variable "backend_subnet_cidr_2" {
  type    = string
  default = "10.100.101.0/24"
}