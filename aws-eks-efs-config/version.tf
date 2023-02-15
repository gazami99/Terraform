terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.47.0"
        }

        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "~> 2.16.1"
        }

        helm = {
            source  = "hashicorp/helm"
            version = "~> 2.8.0"
        }

        null = {
            source  = "hashicorp/null"
            version = "~> 3.2.1"
        }
        
    }

    required_version = "~> 1.3.6"
}

