locals {

    nfs_tcp_port = 2049


    #### storage class 

    efs_storage_class_aws_name = "aws-efs-sc"
} 

data "aws_vpc" "vpc" {
  id = var.vpc_id
}


data "aws_subnets" "private_subnets" {

    filter {
        name   = "vpc-id"
        values = [var.vpc_id]
    }

    filter {
        name   = "tag:Name"
        values = ["Private*"] # insert values here
    }

    depends_on = [

        var.vpc_id
    ]
}

data "aws_availability_zones" "aws_azs" {

    all_availability_zones = true

    filter {
        name   = "opt-in-status"
        values = ["opt-in-not-required"]
    }
}