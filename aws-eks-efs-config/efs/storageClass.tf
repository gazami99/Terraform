resource "kubernetes_storage_class" "aws_efs_sc" {
    metadata {
        name = local.efs_storage_class_aws_name
    }

    storage_provisioner = "efs.csi.aws.com"

    parameters = {
        basePath= "/dynamic_provisioning"
        provisioningMode = "efs-ap"
        fileSystemId     = aws_efs_file_system.aws_efs.id
        directoryPerms   = "755"
        gid = "0"
        uid = "0"


    }

    # mount_options = ["tls","iam"]

}