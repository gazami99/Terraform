resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_iam_role.arn

  vpc_config {

    # when configuring vpn, switch private access value false to true 
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = !var.endpoint_private_access

    subnet_ids              = data.aws_subnets.private_subnets.ids
  }

  version = local.eks_cluster_version

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_iam_role-AmazonEKSClusterPolicy,
  ]
}


resource "aws_security_group_rule" "eks_vpn_security_rule" {

  description       = "vpn-client association"
  type              = "ingress"
  security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"

  source_security_group_id = var.vpn_security_group_id

    depends_on = [
      aws_eks_cluster.eks_cluster
  ]
}

resource "aws_eks_addon" "eks_addon_vpc-cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"

  depends_on = [
      null_resource.iam_role_depends,
      aws_security_group_rule.eks_vpn_security_rule
  ]
}

# add vpc-cni in order to list addons
# resource "aws_eks_addon" "eks_addon_vpc-cni" {
#   cluster_name = aws_eks_cluster.eks_cluster.name
#   addon_name   = "vpc-cni"
# }




