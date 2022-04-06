resource "aws_apigatewayv2_api" "service_api" {
  name          = "${var.project}-${var.service}-${var.env}"
  description   = "Pawnflow service backend api - ${var.env}"
  protocol_type = "HTTP"
  body          = templatefile("api.yaml", {})

  tags = local.tags
}
