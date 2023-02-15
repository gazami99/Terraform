output "vpc_information" {

    description = "vpc_information output"
    value       = {

      vpc             = {
        id   = aws_vpc.myvpc.id
      }

      private_subnets = {

        ids         = aws_subnet.private_subnets[*].id
        cidr_blocks = aws_subnet.private_subnets[*].cidr_block
      }

      public_subnets = {
        
        ids         = aws_subnet.public_subnets[*].id
        cidr_blocks = aws_subnet.public_subnets[*].cidr_block
      }
      

    }
}