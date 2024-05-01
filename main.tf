resource "aws_wafv2_rule_group" "example" {
  name     = var.rule_group_name
  scope    = var.rule_group_scope
  capacity = 2

  dynamic "rule" {
    for_each = lookup(var.block_sanctioned_countries, "enabled", false) ? [0] : []
    content {
      name     = "block-sanctioned-countries"
      priority = var.block_sanctioned_countries["priority"]

      action {
        block {}
      }

      statement {
        geo_match_statement {
          country_codes = var.block_sanctioned_countries["countries_code"]
        }
      }

      dynamic "visibility_config" {
        for_each = var.block_sanctioned_countries["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.rule_group_name}-block-sanctioned-countries-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}
