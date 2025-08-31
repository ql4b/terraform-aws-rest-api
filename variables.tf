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