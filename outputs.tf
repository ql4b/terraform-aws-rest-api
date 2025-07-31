output "rest_apis" {
  description = "API Gateway REST APIs by stage"
  value       = aws_api_gateway_rest_api.api
}

output "api_keys" {
  description = "API Gateway API keys by stage"
  value       = aws_api_gateway_api_key.default
  sensitive   = true
}

output "usage_plan" {
  description = "API Gateway usage plan"
  value       = aws_api_gateway_usage_plan.default
}

output "api_ids" {
  description = "API Gateway REST API IDs by stage"
  value       = { for k, v in aws_api_gateway_rest_api.api : k => v.id }
}

output "api_root_resource_ids" {
  description = "API Gateway root resource IDs by stage"
  value       = { for k, v in aws_api_gateway_rest_api.api : k => v.root_resource_id }
}

output "api_execution_arns" {
  description = "API Gateway execution ARNs by stage"
  value       = { for k, v in aws_api_gateway_rest_api.api : k => v.execution_arn }
}

output "ssm_parameters" {
  description = "SSM parameter names for serverless integration"
  value = {
    rest_api_id             = { for k, v in aws_ssm_parameter.rest_api_id : k => v.name }
    rest_api_root_resource_id = { for k, v in aws_ssm_parameter.rest_api_root_resource_id : k => v.name }
    rest_api_key            = { for k, v in aws_ssm_parameter.rest_api_key : k => v.name }
  }
}