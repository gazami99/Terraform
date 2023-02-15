locals {

    eks_name                  = data.terraform_remote_state.aws_vpc.outputs.eks_name

    hostname                  = data.terraform_remote_state.aws_vpc.outputs.hostname
    hostname_vpc              = data.terraform_remote_state.aws_vpc.outputs.hostname_vpc

    vpc_id                    = data.terraform_remote_state.aws_vpc.outputs.vpc_info.vpc.id

    num_azs_selected          = data.terraform_remote_state.aws_vpc.outputs.num_azs_count

    eks_instance_types        = ["t4g.large"]
    eks_ami_type              = "AL2_ARM_64"

    aws_config_path           = "~/.aws/config"
    aws_credentials_path      = "~/.aws/credentials"
    aws_profile_name          = data.terraform_remote_state.aws_vpc.outputs.aws_profile_name

    private_access            = true
    vpn_security_group_id     = data.terraform_remote_state.aws_vpc.outputs.vpn_security_group_id


}




data "terraform_remote_state" "aws_vpc" {
  backend = "local"
  config = {
    path = "../aws-vpc-vpn-config/terraform.tfstate"
  }
}