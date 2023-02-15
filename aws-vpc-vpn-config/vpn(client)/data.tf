data "aws_acm_certificate" "acm_certificate" {

    domain   = var.hostname
    statuses = ["ISSUED"]
}

