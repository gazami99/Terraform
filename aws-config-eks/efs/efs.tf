resource "aws_efs_file_system" "aws_efs" {
	creation_token = "aws-efs"

	tags = {
		Name = "aws-efs"
  	}
}

resource "aws_efs_mount_target" "aws_efs_mount" {

	count          = var.num_azs_selected

	file_system_id = aws_efs_file_system.aws_efs.id
	subnet_id     = element(data.aws_subnets.private_subnets.ids,count.index)

	security_groups = [aws_security_group.efs_security_group.id]
}