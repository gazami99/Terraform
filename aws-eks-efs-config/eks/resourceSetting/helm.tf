resource "helm_release" "aws-cluster-autoscaler" {
    
    chart      = "cluster-autoscaler"
    name       = "cluster-autoscaler"
    namespace  = "kube-system"
    repository = "https://kubernetes.github.io/autoscaler"
    version    = "~> 9.22.0"

   	values = [
    	templatefile("${path.module}/templates/aws/aws-autoscaler-value.yaml", {

		  autoDiscovery_clusterName      = data.aws_eks_cluster.eks_cluster.name
      aws_Region             = "ap-northeast-2"
      ca_serviceAccount_name = var.ca_serviceAccount_name
    })
  ]
}

resource "helm_release" "aws-efs-csi-driver" {
    
    chart      = "aws-efs-csi-driver"
    name       = "aws-efs-csi-dirver"
    namespace  = "kube-system"
    repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
    version    = "~> 2.3.4"

   	values = [
    	templatefile("${path.module}/templates/aws/aws-efs-csi-driver-value.yaml", {

		  efs_image_repository 			             = local.efs_image_repo_seoul
      efs_csi_controller_serviceAccount_name = var.efs_serviceAccount_name
    })
  ]
}

resource "helm_release" "aws-load-balancer-controller" {
    
    chart      = "aws-load-balancer-controller"
    name       = "aws-load-balancer-controller"
    namespace  = "kube-system"
    repository = "https://aws.github.io/eks-charts"
    version    = "~> 1.4.7"

   	values = [
    	templatefile("${path.module}/templates/aws/aws-alb-controller-value.yaml", {

      alb_serviceAccount_name           = var.alb_serviceAccount_name
      alb_image_repository              = local.alb_image_repo_seoul 
      alb_cluster_name                  = data.aws_eks_cluster.eks_cluster.name
    })
  ]
}

resource "helm_release" "external-dns" {
    
    chart      = "external-dns"
    name       = "external-dns"
    namespace  = local.namespace_name_external-dns
    repository = "https://kubernetes-sigs.github.io/external-dns/"
    version    = "~> 1.12.0"

    values = [templatefile("${path.module}/templates/aws/external-dns-value.yaml", {

          external_dns_serviceAccount_name = local.namespace_name_external-dns

          route53_HostedZone_id    = local.hostedzone_id
          route53_Domain_Name_list = "${join(", ",[var.hostname])}"
      })
    ]

    depends_on = [
      helm_release.aws-load-balancer-controller
    ]
}


##### istio and gateway config
resource "helm_release" "istio-base" {
    
    chart      = "base"
    name       = "istio-base"
    namespace  = local.namespace_name_istio-system
    repository = "https://istio-release.storage.googleapis.com/charts"
    version    = "~> 1.16.1"
}

resource "helm_release" "istiod" {
    
    chart      = "istiod"
    name       = "istiod"
    namespace  = local.namespace_name_istio-system
    repository = "https://istio-release.storage.googleapis.com/charts"
    version    = "~> 1.16.1"
  
    depends_on = [
      helm_release.istio-base
    ]
}

resource "helm_release" "istio-cni" {
    
    chart      = "cni"
    name       = "istio-cni"
    namespace  = "kube-system"
    repository = "https://istio-release.storage.googleapis.com/charts"
    version    = "~> 1.16.1"

    depends_on = [
      helm_release.istiod
    ]
    
}

resource "helm_release" "istio-gateway" {
    
    chart      = "gateway"
    name       = "istio-ingress"
    namespace  = local.namespace_name_istio-gateway
    repository = "https://istio-release.storage.googleapis.com/charts"
    version    = "~> 1.16.1"

    values = [file("${path.module}/templates/istio/istio-gateway-value.yaml")]

    depends_on = [
      helm_release.istio-cni,
      helm_release.aws-load-balancer-controller
    ]
}

resource "helm_release" "local_gatewayAPI" {
    
    chart      = "${path.module}/templates/charts/gatewayAPI"
    name       = "gatewayapi"
    namespace  = local.namespace_name_istio-gateway

    depends_on = [
      helm_release.istio-gateway,
    ]
}

resource "helm_release" "local_config-gateway" {
    
    chart      = "${path.module}/templates/charts/config-gateway"
    name       = "config-gateway"
    namespace  = local.namespace_name_istio-gateway

    values = [
    	templatefile("${path.module}/templates/istio/gateway-value.yaml", {

        alb_acm-arn = "${join(", ",local.certificate_arns)}"
        alb_name = "exteranl-ingress"
        alb_public_subnets_ids = "${join(", ",data.aws_subnets.public_subnets.ids)}"
        dns_hostname = "${var.hostname}"
        }
      )
    ]

    depends_on = [
      helm_release.local_gatewayAPI
    ]
}


### this last depends chain specifiation
### without sequence, terraform destory have problem 
resource "null_resource" "helm_after" {

    depends_on = [
      helm_release.local_config-gateway,
      helm_release.aws-efs-csi-driver,
      helm_release.aws-load-balancer-controller,
      helm_release.external-dns
    ]
}