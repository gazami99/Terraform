output "eks_information" {

    description = "eks_information output"
    value       = {

        name                  = aws_eks_cluster.eks_cluster.name
        id                    = aws_eks_cluster.eks_cluster.id

        endpoint              = aws_eks_cluster.eks_cluster.endpoint
        certificate_authority = aws_eks_cluster.eks_cluster.certificate_authority

        # sa_iam_roles          = zipmap(tolist(data.aws_iam_roles.sa_roles.names),tolist(data.aws_iam_roles.sa_roles.arns))

    }
}