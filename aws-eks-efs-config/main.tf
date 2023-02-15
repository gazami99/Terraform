


#--------------------- provider
provider "aws" {

    shared_config_files      = [pathexpand(local.aws_config_path)]
    shared_credentials_files = [pathexpand(local.aws_credentials_path)]

    profile                  = local.aws_profile_name
}

provider "kubernetes" {


    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    # token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
#----------- For short-lived authentication tokens, an exec-based credential plugin can be used to ensure the token is always up to date 
    exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.name,"--profile",local.aws_profile_name]
        command     = "aws"
    }
}

provider "helm" {

    kubernetes {

    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    # token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
#----------- For short-lived authentication tokens, an exec-based credential plugin can be used to ensure the token is always up to date 
    exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.name,"--profile",local.aws_profile_name]
        command     = "aws"
    }
}

}

provider "null" {
  
}
#-------------------------------------- data

data "aws_eks_cluster" "eks_cluster" {

    name = module.eks.eks_information.id

}

#----------------------------------------- module
# module "vpc" {

#     source                  = "./vpc"
#     name                    = local.vpc_name
#     azs_selected            = local.num_azs_selected     # max -> the number of aws_availability_zones
    
#     main_vpc_cidr           = "10.0.0.0/16"

#     ## required for EKS Tag
#     additional_tags         =  {
#         "kubernetes.io/cluster/${local.eks_name}" = "shared"
#         }
    
# }

# module "vpn" {

#     source  = "./vpn(client)"

#     hostname             = local.hostname_vpc
#     client_cidr_block    = "10.1.0.0/22"

#     private_subnet_cidrs = module.vpc.vpc_information.private_subnets.cidr_blocks
#     vpc_id               = module.vpc.vpc_information.vpc.id
#     count_private_subnet = local.num_azs_selected
#     private_subnet_ids   = module.vpc.vpc_information.private_subnets.ids

#     depends_on = [
#       module.vpc
#     ]
# }

module "eks" {

    source                  = "./eks"

    vpc_id                  = local.vpc_id
    eks_cluster_name        = local.eks_name

    instance_types          = local.eks_instance_types
    ami_type                = local.eks_ami_type

    max_size                = 2
    min_size                = 1
    desired_size            = 1

    ### (Optional) 
    
    # in case of use alb annotation ssl
    hostname                = local.hostname

    # when not specifying mode default is true, only access via vpn except vpc
    endpoint_private_access = local.private_access
    vpn_security_group_id   = local.vpn_security_group_id
}

module "efs" {

    source                       = "./efs"
    vpc_id                       = local.vpc_id
    num_azs_selected             = local.num_azs_selected

    depends_on = [
        module.eks
    ]
}