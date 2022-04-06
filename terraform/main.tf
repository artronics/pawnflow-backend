terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
  backend "s3" {
    profile = "jalal"
    bucket = "terraform-artronics-pawnflow"
    region = "eu-west-2"
  }
}

provider "aws" {
  profile = "jalal"
  region  = "eu-west-2"
}

provider "aws" {
  alias  = "acm_provider"
  region = "eu-west-2"
}
