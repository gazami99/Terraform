resource "aws_security_group" "vpn_security_group" {
  name        = "vpn"
  description = "Allow TLS inbound traffic with vpn"
  vpc_id      = var.vpc_id


  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_ec2_client_vpn_endpoint"  "aws_vpn_client_endpoint" {
  description            = "aws-client-vpn"
  server_certificate_arn = data.aws_acm_certificate.acm_certificate.arn
  client_cidr_block      = var.client_cidr_block
  split_tunnel           = true

    authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = data.aws_acm_certificate.acm_certificate.arn
  }

    connection_log_options {

    enabled               = false
    }

    depends_on = [
      aws_security_group.vpn_security_group
    ]
}

resource "aws_ec2_client_vpn_network_association" "vpn_private_association" {

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.aws_vpn_client_endpoint.id
  subnet_id              = element(var.private_subnet_ids, 0)
  security_groups        = [aws_security_group.vpn_security_group.id]

}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_authorization_rule" {

  count   = var.count_private_subnet

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.aws_vpn_client_endpoint.id
  target_network_cidr    = element(var.private_subnet_cidrs, count.index)

  authorize_all_groups   = true
}


