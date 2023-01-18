locals {

# eks_cluster

    eks_cluster_version     = "1.24"
    
#  eks iam role 
    namespace_kube-system   = "kube-system"

    namespace_default       = "default"
    
    serviceAccount_default  = "default"

    serviceAccount_efs      = "efs"

    serviceAccount_alb      = "alb"

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
}

data "aws_subnets" "vpc_subnets" {

    filter {
        name   = "vpc-id"
        values = [var.vpc_id]
    }
}


data "tls_certificate" "eks_tls_cert" {
    
    url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

    depends_on = [
        aws_eks_cluster.eks_cluster,
    ]
}

data "aws_iam_roles" "sa_roles" {
  name_regex = ".*SA.*"
}