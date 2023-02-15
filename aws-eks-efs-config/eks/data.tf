locals {

# eks_cluster

    eks_cluster_version       = "1.24"
    
#  eks iam role 
    namespace_name_kube-system      = "kube-system"

    namespace_name_calico-system    = "calico-system"

    namespace_name_istio-system     = "istio-system"

    namespace_name_external-dns     = "external-dns"

    namespace_default               = "default"
    
    serviceAccount_default          = "default"

    serviceAccount_efs              = "efs-csi-controller"

    serviceAccount_alb              = "aws-load-balancer-controller"

    serviceAccount_CNI              = "aws-node"

    serviceAccount_ca               = "aws-cluster-autoscaler"

    serviceAccount_external-dns     = "external-dns"


    # annotation sa iam role
        iam_role_SA_efs_Annotations= tomap({
        "eks.amazonaws.com/role-arn" = aws_iam_role.eks_SA_efs_iam_role.arn
        })

        iam_role_SA_alb_Annotations= tomap({
        "eks.amazonaws.com/role-arn" = aws_iam_role.eks_SA_alb_iam_role.arn
        })


        iam_role_SA_CNI_Annotations= tomap({
        "eks.amazonaws.com/role-arn" = aws_iam_role.eks_SA_CNI_iam_role.arn
        })

        iam_role_SA_dns_Annotations= tomap({
        "eks.amazonaws.com/role-arn" = aws_iam_role.eks_SA_dns_iam_role.arn
        })

        iam_role_SA_ca_Annotations= tomap({
        "eks.amazonaws.com/role-arn" = aws_iam_role.eks_SA_ca_iam_role.arn
        })
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

# data "aws_iam_roles" "sa_roles" {
#   name_regex = ".*SA.*"

#   depends_on = [
#     null_resource.kubernetes_depends
#   ]
# }