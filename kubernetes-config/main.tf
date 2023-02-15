
# remote state
provider "kubernetes" {

    host                   = data.terraform_remote_state.aws_eks.outputs.eks_info.endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.aws_eks.outputs.eks_info.certificate_authority[0].data)
    # token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
#----------- For short-lived authentication tokens, an exec-based credential plugin can be used to ensure the token is always up to date 
    exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.aws_eks.outputs.eks_info.name,"--profile",local.aws_profile]
        command     = "aws"
    }
}

provider "helm" {

    kubernetes {

        host                   = data.terraform_remote_state.aws_eks.outputs.eks_info.endpoint
        cluster_ca_certificate = base64decode(data.terraform_remote_state.aws_eks.outputs.eks_info.certificate_authority[0].data)
        # token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
#----------- For short-lived authentication tokens, an exec-based credential plugin can be used to ensure the token is always up to date
        exec {
            api_version = "client.authentication.k8s.io/v1beta1"
            args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.aws_eks.outputs.eks_info.name,"--profile",local.aws_profile]
            command     = "aws"
        }
    }
}


resource "null_resource" "after" {

    depends_on = [
      null_resource.name_space
    ]
  
}

module "helm" {

    source              = "./helm"

    storageClass_name   = data.terraform_remote_state.aws_eks.outputs.efs_info.storageClassName

    depends_on = [
        null_resource.after
    ]
}