resource "null_resource" "kubernetes_depends" {

    depends_on = [
       null_resource.sa_depends,
       null_resource.namespace_depends,
       null_resource.annotations_depends,
    ]
  
}


module "resourceSetting" {

    source = "./resourceSetting"

    vpc_id                  = var.vpc_id
    cluster_name            = aws_eks_cluster.eks_cluster.name
    node_group_name         = aws_eks_node_group.eks_node.node_group_name
    hostname                = var.hostname

    efs_serviceAccount_name = local.serviceAccount_efs
    alb_serviceAccount_name = local.serviceAccount_alb
    ca_serviceAccount_name  = local.serviceAccount_ca


    depends_on = [

       aws_eks_node_group.eks_node,
       null_resource.iam_role_depends,
       null_resource.kubernetes_depends,
    ]
}