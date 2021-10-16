
# variable "region" {
#     default = "us-east-2"
# }

# variable "additional_tags" {
#   default     = {}
#   description = "Additional resource tags"
#   #environment = "Test"
# }

variable "vpc_cidr" {
    default = "192.168.0.0/16"
}

variable "public_cidr" {
    default = "192.168.10.0/24"
}

variable "private_cidr" {
    default = "192.168.20.0/24"
}

variable "enable_dns_support" {
    default = "true"
}

variable "enable_dns_hostnames" {
    default ="true" 
}

variable "enable_classiclink" {
    default = "false"
}

variable "enable_classiclink_dns_support" {
    default = "false"
}

# variable "preferred_number_of_public_subnets" {
#     default = null
# }

# variable "preferred_number_of_private_subnets" {
#     default = []
# }