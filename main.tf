locals {
  stages = var.stages
}

resource "aws_api_gateway_rest_api" "api" {
  for_each = toset(local.stages)
  name     = "${module.this.id}-${each.key}"
  
  tags = module.this.tags
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
  
  tags = module.this.tags
}

resource "aws_api_gateway_usage_plan_key" "default" {
  for_each = toset(local.stages)
  key_id        = aws_api_gateway_api_key.default[each.key].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.default.id
}