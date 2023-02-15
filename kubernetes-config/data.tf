locals {

    aws_profile               = data.terraform_remote_state.aws_vpc.outputs.aws_profile_name

    namespace_name_monitoring = "monitoring"

    namespace_name_sql        = "sql"

    namespace_name_gongo      = "gongo"

    docker-info               = "${file("~/.terraform/sensitive/docker-info.json")}"
}


data "terraform_remote_state" "aws_eks" {
  backend = "local"
  config = {
    path = "../aws-eks-efs-config/terraform.tfstate"
  }
}


data "terraform_remote_state" "aws_vpc" {
  backend = "local"
  config = {
    path = "../aws-vpc-vpn-config/terraform.tfstate"
  }
}