# terraform-aws-rest-api

> Minimal REST API infrastructure with API Gateway, usage plans, and API keys

Terraform module that provisions API Gateway REST APIs with usage plans and API keys across multiple stages. Everything you need for a production API without serverless framework overhead.

## Features

- **Multi-stage APIs** (staging, prod by default)
- **API Keys** with usage plans for each stage
- **Usage plan management** across all stages
- **CloudPosse labeling** for consistent naming

## Usage

```hcl
module "api" {
  source = "git::https://github.com/ql4b/terraform-aws-rest-api.git"
  
  stages = ["staging", "prod"]
  
  context = {
    namespace = "myorg"
    name      = "myapi"
  }
}
```

## Outputs

- `api_ids` - API Gateway REST API IDs by stage
- `api_keys` - API keys by stage (sensitive)
- `api_execution_arns` - Execution ARNs for Lambda permissions

## Integration

```hcl
# Use with Lambda functions
resource "aws_lambda_permission" "api" {
  for_each = module.api.api_ids
  
  statement_id  = "AllowExecutionFromAPIGateway-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api.api_execution_arns[each.key]}/*/*"
}
```