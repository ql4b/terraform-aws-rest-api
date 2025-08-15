variable "stages" {
  type        = list(string)
  description = "List of API stages to create"
  default     = ["staging", "prod"]
}

variable "ssm_prefix" {
  type        = string
  description = "SSM parameter prefix for storing API resource references"
  default     = null
}

variable "endpoint_type" {
  type        = string
  description = "API Gateway endpoint type (e.g., 'REGIONAL', 'EDGE', 'PRIVATE')"
  default     = "REGIONAL"
}