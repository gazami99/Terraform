locals {

    aws_profile = data.terraform_remote_state.aws.outputs.aws_profile_name
}


data "terraform_remote_state" "aws" {
  backend = "local"
  config = {
    path = "../aws-config-eks/terraform.tfstate"
  }
}