resource "kubernetes_annotations" "sa_CNI" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name        = local.serviceAccount_CNI
    namespace   = local.namespace_name_kube-system
  }
  annotations = local.iam_role_SA_CNI_Annotations
}

resource "null_resource" "annotations_depends" {

    depends_on = [
        kubernetes_annotations.sa_CNI,
    ]
}