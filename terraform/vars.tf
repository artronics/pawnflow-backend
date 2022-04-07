variable "project" {
  default = "pawnflow"
}

variable "environment" {
  default = "dev"
}

variable "domain_name" {
  default = "pawnflow.co.uk"
}

variable "service" {
  default = "backend"
}

locals {
  service_domain_name = "api.${var.environment}.${var.domain_name}"
}
locals {
  name_prefix = "${var.project}-${var.service}-${var.environment}"
  tags        = {
    Project     = var.project
    Environment = var.environment
    Tier        = "backend"
  }
}
