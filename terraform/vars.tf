variable "project" {
  default = "pawnflow"
}

variable "env" {
  default = "dev"
}

variable "service" {
  default = "customer"
}

locals {
  tags = {
    Project = var.project
    Environment = var.env
    Tier = "backend"
  }
}
