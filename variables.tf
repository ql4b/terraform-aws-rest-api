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

variable "enable_metrics" {
  type        = bool
  description = "Enable API Gateway metrics"
  default     = true
}

variable "stage_throttle_rate_limit" {
  type        = number
  description = "API Gateway stage throttle rate limit (requests per second)"
  default     = null
}

variable "stage_throttle_burst_limit" {
  type        = number
  description = "API Gateway stage throttle burst limit"
  default     = null
}

variable "throttle_rate_limit" {
  type        = number
  description = "API Gateway usage plan throttle rate limit (requests per second)"
  default     = null
}

variable "throttle_burst_limit" {
  type        = number
  description = "API Gateway usage plan throttle burst limit"
  default     = null
}

variable "quota_limit" {
  type        = number
  description = "API Gateway usage plan quota limit (requests per period)"
  default     = null
}

variable "quota_period" {
  type        = string
  description = "API Gateway usage plan quota period (DAY, WEEK, MONTH)"
  default     = "DAY"
  validation {
    condition     = contains(["DAY", "WEEK", "MONTH"], var.quota_period)
    error_message = "Quota period must be DAY, WEEK, or MONTH."
  }
}

variable "create_usage_plan" {
  description = "Whether to create usage plan and API keys"
  type        = bool
  default     = true
}

variable "api_key_required" {
  description = "Whether to require an API key for API Gateway methods"
  type        = bool
  default     = false
}

variable "description" {
  type        = string
  description = "Description for the API Gateway"
  default     = null
}

variable "cors_configuration" {
  type = object({
    allow_credentials = bool
    allow_headers     = list(string)
    allow_methods     = list(string)
    allow_origins     = list(string)
    expose_headers    = list(string)
    max_age          = number
  })
  description = "CORS configuration for the API Gateway"
  default     = null
}