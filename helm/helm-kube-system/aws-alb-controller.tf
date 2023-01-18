resource "helm_release" "aws_alb" {
    
    chart      = "aws-load-balancer-controller"
    name       = "aws-load-blancer-controller"
    namespace  = local.namespace
    repository = "https://aws.github.io/eks-charts"
    version    = "~> 1.4.7"

   	values = [
    	templatefile("${path.module}/templates/aws-alb-controller-value.yaml", {

      alb_image_repository              = local.alb_image_repo_seoul 
      alb_cluster_name                  = var.eks_cluster_name
      
      alb_cotroller_serviceAccount_name = local.alb_serviceAccount_name

    })
  ]
}