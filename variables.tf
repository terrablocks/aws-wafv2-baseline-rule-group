variable "name" {
  type        = string
  description = "Name of the rule group"
}

variable "description" {
  type        = string
  default     = "Baseline security WAF rule group"
  description = "Description for the rule group"
}

variable "scope" {
  type        = string
  description = "Scope of the rule group. **Note:** Valid value is either **REGIONAL** or **CLOUDFRONT**"

  validation {
    condition     = var.scope == "REGIONAL" || var.scope == "CLOUDFRONT"
    error_message = "scope must be either REGIONAL or CLOUDFRONT"
  }
}

variable "enable_cw_metrics" {
  type        = bool
  default     = true
  description = "Enable CloudWatch metrics for the rule group"
}

variable "block_sanctioned_countries" {
  type = object({
    enabled           = bool
    priority          = optional(number)
    countries_code    = optional(list(string))
    enable_cw_metrics = optional(bool)
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
  description = "Blacklist all incoming traffic from the countries sanctioned by the US. Country codes must follow alpha-2 format as per [ISO](https://www.iso.org/obp/ui) 3166 standards"
}

variable "block_cloudfront_default_domain" {
  type = object({
    enabled           = bool
    priority          = optional(number)
    enable_cw_metrics = optional(bool)
  })

  default = {
    enabled           = true
    priority          = 1
    enable_cw_metrics = true
  }
  description = "Block all incoming traffic if the request host header contains cloudfront domain. This rule prevents bad actors from bypassing the custom domain to which you have mapped cloudfront domain"
}

variable "block_load_balancer_default_domain" {
  type = object({
    enabled           = bool
    priority          = optional(number)
    enable_cw_metrics = optional(bool)
  })

  default = {
    enabled           = true
    priority          = 2
    enable_cw_metrics = true
  }
  description = "Block all incoming traffic if the request host header contains load balancer domain. This rule prevents bad actors from bypassing the custom domain to which you have mapped load balancer domain"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Map of key value pair to associate with the rule group"
}
