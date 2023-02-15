output "efs" {
    value = sensitive(aws_efs_file_system.aws_efs)
}


output "efs_information" {

    description = "efs_information output"
    value       = {

        id               = aws_efs_file_system.aws_efs.id

        storageClassName = local.efs_storage_class_aws_name

    }
}