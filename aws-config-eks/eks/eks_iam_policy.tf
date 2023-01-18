#-------------------------- aws_iam_policy_document_OIDC

data "aws_iam_policy_document" "iam_policy_OIDC_assume_role_policy_SA_efs" {

    source_policy_documents = [templatefile("${path.module}/templates/OIDC_assume_role_policy.json", {

        aws_OIDC_arn          = aws_iam_openid_connect_provider.aws_OIDC.arn 
        aws_OIDC_url          = replace(aws_iam_openid_connect_provider.aws_OIDC.url, "https://", "")

        namespace             = local.namespace_kube-system
      
        serviceAccount_name   = local.serviceAccount_efs

    })]
}


#ServiceAccount iam role alb
data "aws_iam_policy_document" "iam_policy_OIDC_assume_role_policy_SA_alb" {

    source_policy_documents = [templatefile("${path.module}/templates/OIDC_assume_role_policy.json", {

        aws_OIDC_arn          = aws_iam_openid_connect_provider.aws_OIDC.arn 
        aws_OIDC_url          = replace(aws_iam_openid_connect_provider.aws_OIDC.url, "https://", "")

        namespace             = local.namespace_kube-system
      
        serviceAccount_name   = local.serviceAccount_alb

    })]
}





## efs policy
resource "aws_iam_policy" "AmazonEKS_EFS_CSI_Driver_Policy" {

    name        = "AmazonEKS_EFS_CSI_Driver_Policy"
    description = "AmazonEKS_EFS_CSI_Driver_Policy"

    policy = "${file("${path.module}/templates/AmazonEKS_EFS_CSI_Driver_Policy.json")}"

    }


    ## alb
resource "aws_iam_policy" "AmazonEKS_AWS_Load_Balancer_Controller" {

    name        = "AmazonEKS_AWS_Load_Balancer_Controller"
    description = "AmazonEKS_AWS_Load_Balancer_Controller"

    policy = "${file("${path.module}/templates/AmazonEKS_AWS_Load_Balancer_Controller.json")}"
}
