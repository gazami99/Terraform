variable "vpc_id" {

    description = "This is a vpc_id"
    type        = string
}

variable "cluster_name" {
    
    description = "aws_eks_name"
    type        = string
}

variable "node_group_name" {
    
    description = "node_group_name"
    type        = string
}

variable "efs_serviceAccount_name" {
    description = "efs serviceAccount_name granting efs permission"
    type    = string
}

variable "alb_serviceAccount_name" {
    description = "albserviceAccount_name granting efs permission"
    type    = string
}

variable "ca_serviceAccount_name" {
    description = "ca-serviceAccount_name granting autoscaeling permission"
    type    = string
}

variable "hostname" {

    description     = "required for ssl"
    type            = string
    default         = ""
}