resource "aws_eks_node_group" "eks_node" {
    cluster_name    = aws_eks_cluster.eks_cluster.name
    node_group_name = "eks-node"
    node_role_arn   = aws_iam_role.eks_node_iam_role.arn

    ## deploy node in private subenets
    subnet_ids      = data.aws_subnets.private_subnets.ids

    ami_type       = var.ami_type
    instance_types = var.instance_types

    scaling_config {
        desired_size = var.desired_size
        max_size     = var.max_size
        min_size     = var.min_size
    }

  update_config {
    max_unavailable = var.max_unavailable
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_iam_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_iam_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_iam_role-AmazonEC2ContainerRegistryReadOnly,
  ]
}


