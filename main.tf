resource "aws_wafv2_rule_group" "example" {
  name        = var.rule_group_name
  description = var.rule_group_description
  scope       = var.rule_group_scope
  capacity    = 2

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
    cloudwatch_metrics_enabled = var.enable_rule_group_cw_metrics
    metric_name                = "${var.rule_group_name}-waf-rule-group"
    sampled_requests_enabled   = var.enable_rule_group_cw_metrics
  }

  tags = var.tags
}
