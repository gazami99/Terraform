resource "helm_release" "aws_efs" {
    
    chart      = "aws-efs-csi-driver"
    name       = "awsefscsidirver"
    namespace  = local.namespace
    repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
    version    = "~> 2.3.4"

   	values = [
    	templatefile("${path.module}/templates/aws-efs-csi-driver-value.yaml", {

		  efs_image_repository 			        = local.efs_image_repo_seoul

		  efs_cotroller_serviceAccount_name = local.efs_serviceAccount_name
    })
  ]
}