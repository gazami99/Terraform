resource "aws_security_group" "efs_security_group" {
  name        = "efs_security_group"
  description = "Allow nfs inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "nfs from VPC"
    from_port        = local.nfs_tcp_port
    to_port          = local.nfs_tcp_port  # << nfs traffic
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
    # ipv6_cidr_blocks = [data.aws_vpc.vpc.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "efs_security_group"
  }
}