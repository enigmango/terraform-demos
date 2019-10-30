variable "base_name" {
  type        = string
  default     = "passthrough-demo"
  description = "Base name to be included in all resources"
}

variable "instance_count" {
  type    = number
  default = 1
}

# Will be divided into 2 equally-sized subnets
# Must be at least a /24 to support the minimum /25 required for LBs
# Subnet 1 (e.g. 10.200.200.0/25) will be public
# Subnet 2 (e.g. 10.200.200.128/25) will be private
variable "vpc_cidr" {
  type        = string
  default     = "10.200.200.0/24"
  description = "CIDR range for VPC. Will be divided into 2 equally-sized subnets"
}