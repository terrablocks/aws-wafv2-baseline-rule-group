locals {
  # Following docs can be referred to calculate capacity required for each rule
  # https://docs.aws.amazon.com/cli/latest/reference/wafv2/check-capacity.html
  # https://docs.aws.amazon.com/waf/latest/APIReference/API_CheckCapacity.html#API_CheckCapacity_RequestParameters
  rule_group_capacity = sum(flatten(
    [
      # https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-geo-match.html
      lookup(var.block_sanctioned_countries, "enabled", false) ? [1] : [0],

      # https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-string-match.html
      # https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-transformation.html
      # 2 for ENDS_WITH constraint and 10 for text transformations
      lookup(var.block_cloudfront_default_domain, "enabled", false) ? [12] : [0],

      # https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-type-string-match.html
      # https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statement-transformation.html
      # 2 for ENDS_WITH constraint and 10 for text transformations
      lookup(var.block_load_balancer_default_domain, "enabled", false) ? [12] : [0]
    ])
  )
}

resource "aws_wafv2_rule_group" "this" {
  name        = var.name
  description = var.description
  scope       = var.scope
  capacity    = local.rule_group_capacity

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
          metric_name                = "${var.name}-block-sanctioned-countries-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  dynamic "rule" {
    for_each = lookup(var.block_cloudfront_default_domain, "enabled", false) ? [0] : []
    content {
      name     = "block-cloudfront-default-domain"
      priority = var.block_cloudfront_default_domain["priority"]

      action {
        block {}
      }

      statement {
        byte_match_statement {
          field_to_match {
            single_header {
              name = "host"
            }
          }
          positional_constraint = "ENDS_WITH"
          search_string         = ".cloudfront.net"
          text_transformation {
            type     = "NONE"
            priority = 0
          }
        }
      }

      dynamic "visibility_config" {
        for_each = var.block_cloudfront_default_domain["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.name}-block-cloudfront-default-domain-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  dynamic "rule" {
    for_each = lookup(var.block_load_balancer_default_domain, "enabled", false) ? [0] : []
    content {
      name     = "block-load-balancer-default-domain"
      priority = var.block_load_balancer_default_domain["priority"]

      action {
        block {}
      }

      statement {
        byte_match_statement {
          field_to_match {
            single_header {
              name = "host"
            }
          }
          positional_constraint = "ENDS_WITH"
          search_string         = ".elb.amazonaws.com"
          text_transformation {
            type     = "NONE"
            priority = 0
          }
        }
      }

      dynamic "visibility_config" {
        for_each = var.block_load_balancer_default_domain["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.name}-block-load-balancer-default-domain-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.enable_cw_metrics
    metric_name                = "${var.name}-waf-rule-group"
    sampled_requests_enabled   = var.enable_cw_metrics
  }

  tags = var.tags
}
