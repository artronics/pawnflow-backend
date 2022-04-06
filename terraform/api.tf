resource "aws_apigatewayv2_api" "service_api" {
  name          = "${var.project}-${var.service}-${var.env}"
  description   = "Pawnflow service backend api - ${var.env}"
  protocol_type = "HTTP"
  body          = templatefile("api.yaml", {})

  tags = local.tags
}

resource "aws_apigatewayv2_domain_name" "service_api_domain_name" {
  domain_name = local.service_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.service_certificate.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  /*
    dynamic "mutual_tls_authentication" {
      for_each = length(keys(var.mutual_tls_authentication)) == 0 ? [] : [var.mutual_tls_authentication]

      content {
        truststore_uri     = mutual_tls_authentication.value.truststore_uri
        truststore_version = try(mutual_tls_authentication.value.truststore_version, null)
      }
    }
  */

  tags = merge(local.tags, { Name = "${local.app_prefix}-api-domain-name" })
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.service_api.id
  name        = var.env
  auto_deploy = false

  tags = local.tags

  # Bug in terraform-aws-provider with perpetual diff
  lifecycle {
    ignore_changes = [deployment_id]
  }
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.service_api.id
  route_key = "$default"

  #  api_key_required                    = try(each.value.api_key_required, null)
  #  authorization_type                  = try(each.value.authorization_type, "NONE")
  #  authorizer_id                       = try(aws_apigatewayv2_authorizer.this[each.value.authorizer_key].id, each.value.authorizer_id, null)
  #  model_selection_expression          = try(each.value.model_selection_expression, null)
  #  operation_name                      = try(each.value.operation_name, null)
  #  route_response_selection_expression = try(each.value.route_response_selection_expression, null)
  #  target                              = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
  #
  # Not sure what structure is allowed for these arguments...
  #  authorization_scopes = try(each.value.authorization_scopes, null)
  #  request_models  = try(each.value.request_models, null)
}

resource "aws_apigatewayv2_integration" "route" {
  api_id           = aws_apigatewayv2_api.service_api.id
  integration_type = "MOCK"
}

resource "aws_apigatewayv2_deployment" "dep" {
  api_id      = aws_apigatewayv2_api.service_api.id
  description = "Example deployment"

  lifecycle {
    create_before_destroy = true
  }
}
