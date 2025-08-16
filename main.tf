locals {
  stages = var.stages
  endpoint_type = var.endpoint_type
  enable_metrics = var.enable_metrics
}

resource "aws_api_gateway_rest_api" "api" {
  for_each = toset(local.stages)
  name     = "${module.this.id}-${each.key}"

  endpoint_configuration {
    types = [
      local.endpoint_type
    ]
  }
  
  tags = module.this.tags
}

resource "aws_api_gateway_method" "placeholder" {
  for_each      = toset(local.stages)
  rest_api_id   = aws_api_gateway_rest_api.api[each.key].id
  resource_id   = aws_api_gateway_rest_api.api[each.key].root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "placeholder" {
  for_each    = toset(local.stages)
  rest_api_id = aws_api_gateway_rest_api.api[each.key].id
  resource_id = aws_api_gateway_rest_api.api[each.key].root_resource_id
  http_method = aws_api_gateway_method.placeholder[each.key].http_method
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "placeholder" {
  for_each    = toset(local.stages)
  rest_api_id = aws_api_gateway_rest_api.api[each.key].id
  
  depends_on = [
    aws_api_gateway_method.placeholder,
    aws_api_gateway_integration.placeholder
  ]
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.placeholder[each.key].id,
      aws_api_gateway_integration.placeholder[each.key].id,
    ]))
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  for_each      = toset(local.stages)
  stage_name    = each.key
  rest_api_id   = aws_api_gateway_rest_api.api[each.key].id
  deployment_id = aws_api_gateway_deployment.placeholder[each.key].id

  tags = module.this.tags
}


resource "aws_api_gateway_method_settings" "settings" {
  for_each    = toset(local.stages)
  rest_api_id = aws_api_gateway_rest_api.api[each.key].id
  stage_name  = aws_api_gateway_stage.stage[each.key].stage_name
  method_path = "*/*"
  
  settings {
    metrics_enabled = local.enable_metrics
  }
}

resource "aws_api_gateway_api_key" "default" {
  for_each = toset(local.stages)
  name = join("-", [
    module.this.id,
    "key",
    each.key
  ])
  
  tags = module.this.tags
}

resource "aws_api_gateway_usage_plan" "default" {
  name = "${module.this.id}-default-plan"

  dynamic "api_stages" {
    for_each = toset(local.stages)
    content {
      api_id = aws_api_gateway_rest_api.api[api_stages.value].id
      stage  = api_stages.value
    }
  }
  
  depends_on = [aws_api_gateway_stage.stage]
  
  tags = module.this.tags
}

resource "aws_api_gateway_usage_plan_key" "default" {
  for_each = toset(local.stages)
  key_id        = aws_api_gateway_api_key.default[each.key].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.default.id
}