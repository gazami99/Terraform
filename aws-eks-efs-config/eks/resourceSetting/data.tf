locals {
#   namespace

    namespace_name_istio-system   = "istio-system"

    namespace_name_istio-gateway   = "istio-gateway"

    namespace_name_external-dns   = "external-dns"


#   helm variable
    efs_image_repo_seoul    = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/eks/aws-efs-csi-driver"

    alb_image_repo_seoul    = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"

#  external-dns attribute

    hostedzone_id = var.hostname == "" ? "" : "${aws_route53domains_registered_domain.aws_registered_domain[0].id}"

# annotiona alb certification

    certificate_arns = tolist(var.hostname == "" ? [""] : flatten([data.aws_acm_certificate.acm_certificate[*].arn]))

# routing  alb-ingress  to istio-ingress

    # annotations_common-external-ingress = yamlencode({
        
    #         "kubernetes.io/ingress.class" :"alb",
    #         "alb.ingress.kubernetes.io/listen-ports" : "[{\"HTTP\": 80}, {\"HTTPS\": 443}]", 
    #         "alb.ingress.kubernetes.io/actions.ssl-redirect" : "443",
    #         "alb.ingress.kubernetes.io/load-balancer-name" : "common-external-ingress",
    #         "alb.ingress.kubernetes.io/scheme": "internet-facing"
    #         "alb.ingress.kubernetes.io/target-type": "instance"
    #         "alb.ingress.kubernetes.io/subnets" : "${join(", ",data.aws_subnets.public_subnets.ids)}"
    #         "alb.ingress.kubernetes.io/certificate-arn" : "${join(", ",local.certificate_arns)}"
    #         "external-dns.alpha.kubernetes.io/hostname": "${var.hostname}"
    #     }
    # )
}

# The aws_route53domains_registered_domain resource behaves differently from normal resources in that 
# if a domain has been registered, Terraform does not register this domain,
# but instead "adopts" it into management. terraform destroy does not delete the domain
# but does remove the resource  from Terraform state.
resource "aws_route53domains_registered_domain" "aws_registered_domain" {

    count = var.hostname != "" ? 1 : 0 

    domain_name = var.hostname
}

data "aws_eks_cluster" "eks_cluster" {

    name = var.cluster_name
}

data "aws_eks_node_group" "example" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
}

data "aws_subnets" "public_subnets" {

    filter {
        name   = "vpc-id"
        values = [var.vpc_id]
    }

    filter {
        name   = "tag:Name"
        values = ["Public*"] # insert values here
    }
}

data "aws_acm_certificate" "acm_certificate" {

    count = var.hostname != "" ? 1 : 0 

    domain   = var.hostname
    statuses = ["ISSUED"]
}

