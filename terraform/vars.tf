variable "project" {
  default = "pawnflow"
}

variable "env" {
  default = "dev"
}

variable "domain_name" {
  default = "pawnflow.co.uk"
}

variable "service" {
  default = "backend"
}

locals {
  service_domain_name = "api.${var.env}.${var.domain_name}"
}
locals {
  app_prefix = "${var.project}-${var.env}"
  tags       = {
    Project     = var.project
    Environment = var.env
    Tier        = "backend"
  }
}
