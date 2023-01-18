output "vpc_information" {

    description = "vpc_information output"
    value       = {

      vpc             = {
        id   = aws_vpc.myvpc.id
      }

      public_subnets = {

        ids = aws_subnet.private_subnets[*].id
      }

      private_subnets = {
        
        ids = aws_subnet.public_subnets[*].id
      }
      

    }
}