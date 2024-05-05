
<!-- BEGIN_TF_DOCS -->
# Create a baseline rule group

![License](https://img.shields.io/github/license/terrablocks/aws-wafv2-base-rule-group?style=for-the-badge) ![Tests](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-wafv2-base-rule-group/tests.yml?branch=main&label=Test&style=for-the-badge) ![Checkov](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-wafv2-base-rule-group/checkov.yml?branch=main&label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-wafv2-base-rule-group?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-wafv2-base-rule-group?style=for-the-badge)

This terraform module will deploy the following services:
- WAFv2 Rule Group

# Usage Instructions
## Example
```hcl
module "wafv2_rule_group" {
  source = "github.com/terrablocks/aws-wafv2-base-rule-group.git?ref=" # Always use `ref` to point module to a specific version or hash

  name  = "baseline-waf-rule-group"
  scope = "REGIONAL"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8.0 |
| aws | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| block_cloudfront_default_domain | Block all incoming traffic if the request host header contains cloudfront domain. This rule prevents bad actors from bypassing the custom domain to which you have mapped cloudfront domain | ```object({ enabled = bool priority = optional(number) enable_cw_metrics = optional(bool) })``` | ```{ "enable_cw_metrics": true, "enabled": true, "priority": 1 }``` | no |
| block_load_balancer_default_domain | Block all incoming traffic if the request host header contains load balancer domain. This rule prevents bad actors from bypassing the custom domain to which you have mapped load balancer domain | ```object({ enabled = bool priority = optional(number) enable_cw_metrics = optional(bool) })``` | ```{ "enable_cw_metrics": true, "enabled": true, "priority": 2 }``` | no |
| block_sanctioned_countries | Blacklist all incoming traffic from the countries sanctioned by the US. Country codes must follow alpha-2 format as per [ISO](https://www.iso.org/obp/ui) 3166 standards | ```object({ enabled = bool priority = optional(number) countries_code = optional(list(string)) enable_cw_metrics = optional(bool) })``` | ```{ "countries_code": [ "CU", "IR", "KP", "RU", "SY" ], "enable_cw_metrics": true, "enabled": true, "priority": 0 }``` | no |
| description | Description for the rule group | `string` | `"Baseline security WAF rule group"` | no |
| enable_cw_metrics | Enable CloudWatch metrics for the rule group | `bool` | `true` | no |
| name | Name of the rule group | `string` | n/a | yes |
| scope | Scope of the rule group. **Note:** Valid value is either **REGIONAL** or **CLOUDFRONT** | `string` | n/a | yes |
| tags | Map of key value pair to associate with the rule group | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the WAF rule group |
| capacity | WCU (web ACL capacity units) required for the WAF rule group |
| id | ID of the WAF rule group |

<!-- END_TF_DOCS -->
