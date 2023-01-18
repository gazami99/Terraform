resource "kubernetes_storage_class" "aws_efs_sc" {
    metadata {
        name = local.efs_storage_class_aws_name
    }

    storage_provisioner = "efs.csi.aws.com"

    parameters = {

        provisioningMode = "efs-ap"
        fileSystemId     = local.efs_fileSystemId
        directoryPerms   = "700"
        gidRangeStart    = "1000"
        gidRangeEnd      = "2000"

    }

    # mount_options = ["tls","iam"]

}