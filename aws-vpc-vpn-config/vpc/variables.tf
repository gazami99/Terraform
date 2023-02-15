# Set VPC Enviroment
variable "name" {

    description = "This is Prefix Name"
    type        = string
}

variable "main_vpc_cidr" {

    description = "Set VPC CIDR recommend 10.0.0.0/16" 
    type = string
    default = "10.0.0.0/16"
}

 variable "azs_selected" {

    description = "Availability Zones"
    type        = number
}

variable "all_cidr" {

    description = "Allow all"
    type = string
    default = "0.0.0.0/0"
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}