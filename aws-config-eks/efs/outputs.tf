output "efs" {
    value = sensitive(aws_efs_file_system.aws_efs)
}


output "eks_information" {

    description = "efs_information output"
    value       = {

        id    = aws_efs_file_system.aws_efs.id

    }
}