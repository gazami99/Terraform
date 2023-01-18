locals {

    namespace = "kube-system"

    efs_serviceAccount_name = "efs"
    efs_image_repo_seoul    = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/eks/aws-efs-csi-driver"

    alb_serviceAccount_name = "alb"
    alb_image_repo_seoul    = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
}


