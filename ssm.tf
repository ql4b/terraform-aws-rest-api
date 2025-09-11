locals {
  ssm_prefix = var.ssm_prefix != null ? var.ssm_prefix : "/${module.this.namespace}/${module.this.name}"
}

resource "aws_ssm_parameter" "rest_api_id" {
  for_each = toset(local.stages)
  name     = "${local.ssm_prefix}/${each.key}/restApiId"
  type     = "String"
  value    = aws_api_gateway_rest_api.api[each.key].id
  
  tags = module.this.tags
}

resource "aws_ssm_parameter" "rest_api_root_resource_id" {
  for_each = toset(local.stages)
  name     = "${local.ssm_prefix}/${each.key}/restApiRootResourceId"
  type     = "String"
  value    = aws_api_gateway_rest_api.api[each.key].root_resource_id
  
  tags = module.this.tags
}

resource "aws_ssm_parameter" "rest_api_key" {
  for_each = var.create_usage_plan ? toset(local.stages) : []
  name     = "${local.ssm_prefix}/${each.key}/restApiKey"
  type     = "String"
  value    = aws_api_gateway_api_key.default[each.key].name
  
  tags = module.this.tags
}