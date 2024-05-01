resource "aws_wafv2_rule_group" "example" {
  name     = var.rule_group_name
  scope    = var.rule_group_scope
  capacity = 2

  dynamic "rule" {
    for_each = var.block_sanctioned_countries ? [0] : []
    content {
      name     = "block-sanctioned-countries-rule"
      priority = 1

      action {
        block {}
      }

      statement {
        geo_match_statement {
          country_codes = var.sanctioned_countries_code
        }
      }

      dynamic "visibility_config" {
        for_each = var.block_sanctioned_countries && var.enable_cw_metrics_block_sanctioned_countries ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.rule_group_name}-block-sanctioned-countries-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }
}
