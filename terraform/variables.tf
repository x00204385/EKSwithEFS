#   default = "ami-0333305f9719618c7"
#   default = "ami-0cc4e06e6e710cd94" Ubuntu 20.04 focal


# variable "region" {
#   default = "eu-west-1"
# }

# variable "primary" {
#   type        = bool
#   description = "Determine whether this is the primary or standby region"
# }


# variable "vpc_cidr_block" {
#   default = "10.0.0.0/16"
# }

# variable "public_subnet_cidr_blocks" {
#   default = ["10.0.1.0/24", "10.0.3.0/24"]
# }

# variable "private_subnet_cidr_blocks" {
#   default = ["10.0.2.0/24", "10.0.4.0/24"]
# }


# variable "availability_zones" {
#   default = ["eu-west-1a", "eu-west-1b"]
# }

# variable "profile" {
#   default = "tud-admin"
# }

# variable "key-pair" {
#   default = "tud-aws"
# }

# variable "instance-ami" {
#   default = "ami-0cc4e06e6e710cd94"
# }

variable "db_username" {
  default = "wp_user"
}

variable "db_password" {
  default = "Computing1"
}

