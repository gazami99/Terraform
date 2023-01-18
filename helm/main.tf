
# remote state
provider "kubernetes" {

    host                   = data.terraform_remote_state.aws.outputs.eks_info.endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.aws.outputs.eks_info.certificate_authority[0].data)
    # token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
#----------- For short-lived authentication tokens, an exec-based credential plugin can be used to ensure the token is always up to date 
    exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.aws.outputs.eks_info.name,"--profile",local.aws_profile]
        command     = "aws"
    }
}

provider "helm" {

    kubernetes {

        host                   = data.terraform_remote_state.aws.outputs.eks_info.endpoint
        cluster_ca_certificate = base64decode(data.terraform_remote_state.aws.outputs.eks_info.certificate_authority[0].data)
        # token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
#----------- For short-lived authentication tokens, an exec-based credential plugin can be used to ensure the token is always up to date
        exec {
            api_version = "client.authentication.k8s.io/v1beta1"
            args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.aws.outputs.eks_info.name,"--profile",local.aws_profile]
            command     = "aws"
        }
    }
}


module "kubernetes" {
    source       = "./kubernetes"

    eks_sa_iam_roles     = data.terraform_remote_state.aws.outputs.eks_info.sa_iam_roles
    efs_id               = data.terraform_remote_state.aws.outputs.efs_info.id
}


module "helm-kube-system" {

    source              = "./helm-kube-system"
    
    eks_cluster_name    = data.terraform_remote_state.aws.outputs.eks_info.name

    depends_on = [
        module.kubernetes
    ]
}

module "helm-istio-system" {

    source = "./helm-istio-system"

    depends_on = [
        module.helm-kube-system
    ]
}

module "helm-monitoring" {

    source             = "./helm-monitoring"

    depends_on = [
        module.helm-kube-system
    ]
}

