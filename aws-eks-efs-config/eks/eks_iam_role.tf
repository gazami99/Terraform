# oidc
resource "aws_iam_openid_connect_provider" "aws_OIDC" {

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.eks_tls_cert.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.eks_tls_cert.url
}

# ------ eks_cluster_iam_role
resource "aws_iam_role" "eks_cluster_iam_role" {
    name               = "eks-cluster-iam_role"
    assume_role_policy = templatefile("${path.module}/templates/iam/assume_role_policy.json", {
      
        resource = "eks"
    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_iam_role-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster_iam_role.name
}

#----- eks_node iam role

resource "aws_iam_role" "eks_node_iam_role" {
    name               = "eks-node-iam_role"
    assume_role_policy = templatefile("${path.module}/templates/iam/assume_role_policy.json", {
      
        resource = "ec2"
  })
}

#---------------------------- eks iam_role for eks_node
resource "aws_iam_role_policy_attachment" "eks_node_iam_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_iam_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_iam_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_iam_role.name
}
#---------------------------- eks iam_role for service account


# Service Account iam role  for efs
resource "aws_iam_role" "eks_SA_efs_iam_role" {
    assume_role_policy = data.aws_iam_policy_document.iam_policy_OIDC_assume_role_policy_SA_efs.json
    name               = "eks_SA_efs_iam_role"
}

resource "aws_iam_role_policy_attachment" "eks_SA_iam_role-AmazonEKS_EFS_CSI_Driver_Policy" {
    policy_arn = aws_iam_policy.AmazonEKS_EFS_CSI_Driver_Policy.arn
    role       = aws_iam_role.eks_SA_efs_iam_role.name
}


# Service Account iam role for alb

resource "aws_iam_role" "eks_SA_alb_iam_role" {
    assume_role_policy = data.aws_iam_policy_document.iam_policy_OIDC_assume_role_policy_SA_alb.json
    name               = "eks_SA_alb_iam_role"
}

resource "aws_iam_role_policy_attachment" "eks_SA_iam_role-AmazonEKS_AWS_Load_Balancer_Controller" {
    policy_arn = aws_iam_policy.AmazonEKS_AWS_Load_Balancer_Controller.arn
    role       = aws_iam_role.eks_SA_alb_iam_role.name
}


# Service Account iam role for  CNI

resource "aws_iam_role" "eks_SA_CNI_iam_role" {
    assume_role_policy = data.aws_iam_policy_document.iam_policy_OIDC_assume_role_policy_SA_CNI.json
    name               = "eks_SA_CNI_iam_role"
}

resource "aws_iam_role_policy_attachment" "eks_SA_iam_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_SA_CNI_iam_role.name
}

# Service Account iam role for ca

resource "aws_iam_role" "eks_SA_ca_iam_role" {
    assume_role_policy = data.aws_iam_policy_document.iam_policy_OIDC_assume_role_policy_SA_ca.json
    name               = "eks_SA_ca_iam_role"
}

resource "aws_iam_role_policy_attachment" "eks_SA_iam_role-AmazonEKS_Cluster_Autoscaler_Policy" {
    policy_arn = aws_iam_policy.AmazonEKS_Cluster_Autoscaler_Policy.arn
    role       = aws_iam_role.eks_SA_ca_iam_role.name
}

# Service Account iam role for route53

resource "aws_iam_role" "eks_SA_dns_iam_role" {
    assume_role_policy = data.aws_iam_policy_document.iam_policy_OIDC_assume_role_policy_SA_dns.json
    name               = "eks_SA_dns_iam_role"
}

resource "aws_iam_role_policy_attachment" "eks_SA_iam_role-Amazon_Route53" {
    policy_arn = aws_iam_policy.Amazon_Route53.arn
    role       = aws_iam_role.eks_SA_dns_iam_role.name
}

#--------------------- IAM depengency
resource "null_resource" "iam_role_depends" {


    depends_on = [
        aws_iam_role_policy_attachment.eks_cluster_iam_role-AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.eks_SA_iam_role-AmazonEKS_AWS_Load_Balancer_Controller,
        aws_iam_role_policy_attachment.eks_SA_iam_role-AmazonEKS_EFS_CSI_Driver_Policy,
        aws_iam_role_policy_attachment.eks_SA_iam_role-AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.eks_node_iam_role-AmazonEC2ContainerRegistryReadOnly,
        aws_iam_role_policy_attachment.eks_node_iam_role-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.eks_SA_iam_role-Amazon_Route53,
        aws_iam_role_policy_attachment.eks_SA_iam_role-AmazonEKS_Cluster_Autoscaler_Policy,
    ]

}