resource "kubernetes_service_account" "sa_efs" {
    metadata {

        name        = local.serviceAccount_efs
        namespace   = local.namespace_name_kube-system 

        annotations = local.iam_role_SA_efs_Annotations
    }
}

resource "kubernetes_service_account" "sa_alb" {
    metadata {

        name        = local.serviceAccount_alb
        namespace   = local.namespace_name_kube-system

        annotations = local.iam_role_SA_alb_Annotations
    }
}

resource "kubernetes_service_account" "sa_ca" {
    metadata {

        name        = local.serviceAccount_ca
        namespace   = local.namespace_name_kube-system

        annotations = local.iam_role_SA_ca_Annotations
    }
}

resource "kubernetes_service_account" "sa_dns" {
    metadata {

        name        = local.serviceAccount_external-dns
        namespace   = local.namespace_name_external-dns

        annotations = local.iam_role_SA_dns_Annotations
    }
}

resource "null_resource" "sa_depends" {

    depends_on = [
        kubernetes_service_account.sa_efs,
        kubernetes_service_account.sa_alb,
        kubernetes_service_account.sa_ca,
        kubernetes_service_account.sa_dns
    ]
}