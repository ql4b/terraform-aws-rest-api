variable "stages" {
  type        = list(string)
  description = "List of API stages to create"
  default     = ["staging", "prod"]
}