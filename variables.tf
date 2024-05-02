variable "rule_group_name" {
  type        = string
  description = "Name of the rule group"
}

variable "rule_group_description" {
  type        = string
  default     = "Baseline security WAF rule group"
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

variable "block_cloudfront_default_domain" {
  type = object({
    enabled           = bool
    priority          = number
    enable_cw_metrics = bool
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
    priority          = number
    enable_cw_metrics = bool
  })

  default = {
    enabled           = true
    priority          = 2
    enable_cw_metrics = true
  }
  description = "Block all incoming traffic if the request host header contains load balancer domain. This rule prevents bad actors from bypassing the custom domain to which you have mapped load balancer domain"
}

variable "enable_aws_managed_common_rule_set" {
  type = object({
    enabled           = bool
    priority          = number
    enable_cw_metrics = bool
  })

  default = {
    enabled           = true
    priority          = 3
    enable_cw_metrics = true
  }
  description = "Add [AWSManagedRulesCommonRuleSet](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-crs) to the rule group. Protects against wide range of vulnerabilities described in OWASP Top 10"
}

variable "enable_aws_known_bad_input_rule_set" {
  type = object({
    enabled           = bool
    priority          = number
    enable_cw_metrics = bool
  })

  default = {
    enabled           = true
    priority          = 4
    enable_cw_metrics = true
  }
  description = "Add [AWSManagedRulesKnownBadInputsRuleSet](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-known-bad-inputs) to the rule group. Protects against malicious request patterns to prevent discovery of vulnerabilities"
}

variable "enable_aws_ip_reputation_rule_set" {
  type = object({
    enabled           = bool
    priority          = number
    enable_cw_metrics = bool
  })

  default = {
    enabled           = true
    priority          = 5
    enable_cw_metrics = true
  }
  description = "Add [AWSManagedRulesAmazonIpReputationList](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-ip-rep.html#aws-managed-rule-groups-ip-rep-amazon) to the rule group. Protects against requests origination from know bot IPs"
}

variable "enable_aws_sql_injection_rule_set" {
  type = object({
    enabled           = bool
    priority          = number
    enable_cw_metrics = bool
  })

  default = {
    enabled           = true
    priority          = 6
    enable_cw_metrics = true
  }
  description = "Add [AWSManagedRulesSQLiRuleSet](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-sql-db) to the rule group. Protects against malicious requests trying to exploit SQL vulnerabilities"
}

variable "enable_aws_linux_rule_set" {
  type = object({
    enabled           = bool
    priority          = number
    enable_cw_metrics = bool
  })

  default = {
    enabled           = true
    priority          = 7
    enable_cw_metrics = true
  }
  description = "Add [AWSManagedRulesLinuxRuleSet](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-linux-os) to the rule group. Protects against requests trying to exploit Linux specific vulnerabilities"
}

variable "enable_aws_windows_rule_set" {
  type = object({
    enabled           = bool
    priority          = number
    enable_cw_metrics = bool
  })

  default = {
    enabled           = true
    priority          = 8
    enable_cw_metrics = true
  }
  description = "Add [AWSManagedRulesWindowsRuleSet](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-windows-os) to the rule group. Protects against requests trying to exploit Windows specific vulnerabilities"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of key value pair to associate with the rule group"
}
