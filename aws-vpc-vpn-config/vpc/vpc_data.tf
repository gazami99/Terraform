data "aws_availability_zones" "aws_azs" {

    all_availability_zones = true

    filter {
        name   = "opt-in-status"
        values = ["opt-in-not-required"]
    }
}

