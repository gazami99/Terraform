#-------------------------- aws_iam_policy_document_OIDC

data "aws_iam_policy_document" "iam_policy_OIDC_assume_role_policy_SA_efs" {

    source_policy_documents = [templatefile("${path.module}/templates/iam/OIDC_assume_role_policy.json", {

        aws_OIDC_arn          = aws_iam_openid_connect_provider.aws_OIDC.arn 
        aws_OIDC_url          = replace(aws_iam_openid_connect_provider.aws_OIDC.url, "https://", "")

        namespace             = local.namespace_name_kube-system
      
        serviceAccount_name   = local.serviceAccount_efs

    })]
}


#ServiceAccount iam role alb
data "aws_iam_policy_document" "iam_policy_OIDC_assume_role_policy_SA_alb" {

    source_policy_documents = [templatefile("${path.module}/templates/iam/OIDC_assume_role_policy.json", {

        aws_OIDC_arn          = aws_iam_openid_connect_provider.aws_OIDC.arn 
        aws_OIDC_url          = replace(aws_iam_openid_connect_provider.aws_OIDC.url, "https://", "")

        namespace             = local.namespace_name_kube-system
      
        serviceAccount_name   = local.serviceAccount_alb

    })]
}

#ServiceAccount iam role ca
data "aws_iam_policy_document" "iam_policy_OIDC_assume_role_policy_SA_ca" {

    source_policy_documents = [templatefile("${path.module}/templates/iam/OIDC_assume_role_policy.json", {

        aws_OIDC_arn          = aws_iam_openid_connect_provider.aws_OIDC.arn 
        aws_OIDC_url          = replace(aws_iam_openid_connect_provider.aws_OIDC.url, "https://", "")

        namespace             = local.namespace_name_kube-system
      
        serviceAccount_name   = local.serviceAccount_ca

    })]
}

#ServiceAccount iam role CNI
data "aws_iam_policy_document" "iam_policy_OIDC_assume_role_policy_SA_CNI" {

    source_policy_documents = [templatefile("${path.module}/templates/iam/OIDC_assume_role_policy.json", {

        aws_OIDC_arn          = aws_iam_openid_connect_provider.aws_OIDC.arn 
        aws_OIDC_url          = replace(aws_iam_openid_connect_provider.aws_OIDC.url, "https://", "")

        namespace             = local.namespace_name_kube-system
      
        serviceAccount_name   = local.serviceAccount_CNI

    })]
}

#ServiceAccount iam role dns
data "aws_iam_policy_document" "iam_policy_OIDC_assume_role_policy_SA_dns" {

    source_policy_documents = [templatefile("${path.module}/templates/iam/OIDC_assume_role_policy.json", {

        aws_OIDC_arn          = aws_iam_openid_connect_provider.aws_OIDC.arn 
        aws_OIDC_url          = replace(aws_iam_openid_connect_provider.aws_OIDC.url, "https://", "")

        namespace             = local.namespace_name_external-dns
      
        serviceAccount_name   = local.serviceAccount_external-dns

    })]
}


## efs policy
resource "aws_iam_policy" "AmazonEKS_EFS_CSI_Driver_Policy" {

    name        = "AmazonEKS_EFS_CSI_Driver_Policy"
    description = "AmazonEKS_EFS_CSI_Driver_Policy"

    policy = "${file("${path.module}/templates/iam/AmazonEKS_EFS_CSI_Driver_Policy.json")}"

    }


    ## alb
resource "aws_iam_policy" "AmazonEKS_AWS_Load_Balancer_Controller" {

    name        = "AmazonEKS_AWS_Load_Balancer_Controller"
    description = "AmazonEKS_AWS_Load_Balancer_Controller"

    policy = "${file("${path.module}/templates/iam/AmazonEKS_AWS_Load_Balancer_Controller.json")}"
}


### route 53 policy

resource "aws_iam_policy" "Amazon_Route53" {

    name        = "Amazon_Route53"
    description = "Amazon_Route53"

    policy = "${file("${path.module}/templates/iam/Amazon_Route53.json")}"
}

#### cluster AutoScaling policy

resource "aws_iam_policy" "AmazonEKS_Cluster_Autoscaler_Policy" {

    name        = "AmazonEKSClusterAutoscalerPolicy"
    description = "AmazonEKSClusterAutoscalerPolicy"


    policy =templatefile("${path.module}/templates/iam/cluster_autoscaler_policy.json", {

        eks_name = var.eks_cluster_name

    })
}
