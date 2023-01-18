locals{

    name_space_kube_system = "kube-system"


    ### service Acoount

    iam_role_SA_efs_Annotations= tomap({

        "eks.amazonaws.com/role-arn" = var.eks_sa_iam_roles["eks_SA_efs_iam_role"]
    })

    iam_role_SA_alb_Annotations= tomap({

        "eks.amazonaws.com/role-arn" = var.eks_sa_iam_roles["eks_SA_alb_iam_role"]
    })

    efs_fileSystemId = var.efs_id

    efs_storage_class_aws_name = "efs-sc"


    #### namespace.tf


    namespace_monitoring_name = "monitoring"

    namespace_istio-system_name = "istio-system"

    namespace_istio-ingress_name = "istio-ingress"

}

