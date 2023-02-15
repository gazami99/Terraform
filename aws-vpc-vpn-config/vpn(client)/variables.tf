variable "vpc_id" {

    description = "This is a vpc_id"
    type        = string
}

variable "count_private_subnet" {

    description = "count of private subnet"
    type        = number
}

variable "private_subnet_ids" {

    description = "private subnet ids"
    type        = list(string)

}

variable "private_subnet_cidrs" {

    description = "private subnet cidr"
    type        = list(string)

}

variable "hostname" {

    description = "acm host name"
    type        = string
}

variable "client_cidr_block" {

    description = "clinet_cidr_block"
    type        = string
    default = "10.0.0.0/22"
}