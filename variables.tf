variable "rule_group_name" {
  type        = string
  description = "Name of the rule group"
}

variable "rule_group_description" {
  type        = string
  default     = "Essential security rule group"
  description = "Description for the rule group"
}

variable "rule_group_scope" {
  type        = string
  description = "Scope of the rule group. **Note:** Valid value is either **REGIONAL** or **CLOUDFRONT**"

  validation {
    condition     = var.rule_group_scope == "REGIONAL" || var.rule_group_scope == "CLOUDFRONT"
    error_message = "rule_group_scope must be either REGIONAL or CLOUDFRONT"
  }
}

variable "enable_rule_group_cw_metrics" {
  type        = bool
  default     = true
  description = "Enable CloudWatch metrics for the rule group"
}

variable "block_sanctioned_countries" {
  type = object({
    enabled           = bool
    priority          = number
    countries_code    = list(string)
    enable_cw_metrics = bool
  })

  default = {
    enabled  = true
    priority = 0
    countries_code = [
      "CU", # Cuba
      "IR", # Iran
      "KP", # N. Korea
      "RU", # Russia
      "SY"  # Syria
    ]
    enable_cw_metrics = true
  }
  description = "Blacklist all incoming traffic from the countries sanctioned by the US"
}

# variable "block_aws_default_domain" {
#   type = object({
#     enabled          = bool
#     cloudfront       = bool
#     load_balancer    = bool
#     http_api_gateway = bool
#   })

#   default = {
#     enabled          = true
#     cloudfront       = true
#     load_balancer    = true
#     http_api_gateway = true
#   }
#   description = "Block all incoming traffic if the request host header contains aws service default domain. This rule prevents bad actors from bypassing the custom domain to which you have mapped the AWS service"
# }

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of key value pair to associate with the rule group"
}
