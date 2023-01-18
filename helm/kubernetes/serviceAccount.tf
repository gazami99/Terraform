resource "kubernetes_service_account" "sa_efs" {
    metadata {

        name = "efs"
        namespace = "kube-system"

        annotations = local.iam_role_SA_efs_Annotations
    }
 
}


resource "kubernetes_service_account" "sa_alb" {
    metadata {

        name = "alb"
        namespace = "kube-system"

        annotations = local.iam_role_SA_alb_Annotations
    }
 
}