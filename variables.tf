variable "rule_group_name" {
  type        = string
  description = "Name of the rule group"
}

variable "rule_group_scope" {
  type        = string
  description = "Scope of the rule group. **Note:** Valid value is either **REGIONAL** or **CLOUDFRONT**"

  validation {
    condition     = var.rule_group_scope == "REGIONAL" || var.rule_group_scope == "CLOUDFRONT"
    error_message = "rule_group_scope must be either REGIONAL or CLOUDFRONT"
  }
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
  description = "Blacklist countries sanctioned by the US"
}

# variable "block_sanctioned_countries" {
#   type = bool
#   default = true
#   description = "Whether to block all incoming traffic from the sanctioned countries"
# }

# variable "sanctioned_countries_code" {
#   type = list(string)
#   default = [
#     "CU", # Cuba
#     "IR", # Iran
#     "KP", # N. Korea
#     "RU", # Russia
#     "SY"  # Syria
#   ]
#   description = "List of countries that are sanctioned by the US"
# }

# variable "enable_cw_metrics_block_sanctioned_countries" {
#   type = bool
#   default = true
#   description = "Enable CloudWatch metric for **block_sanctioned_countries** rule"
# }
