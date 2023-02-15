terraform {
    required_providers {

        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "~> 2.16.1"
        }

        helm = {
            source  = "hashicorp/helm"
            version = "~> 2.8.0"
        }

        random = {
            source  = "hashicorp/random"
            version = "~> 3.4.3"
        }

        null = {
            source  = "hashicorp/null"
            version = "~> 3.2.1"
        }
    }

    required_version = "~> 1.3"
}

