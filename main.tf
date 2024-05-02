locals {
  rule_group_capacity = flatten(
    [
      lookup(var.block_sanctioned_countries, "enabled", false) ? [0] : [0]
    ]
  )
}

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
          metric_name                = "${var.rule_group_name}-block-cloudfront-default-domain-rule-waf"
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
          metric_name                = "${var.rule_group_name}-block-load-balancer-default-domain-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  dynamic "rule" {
    for_each = lookup(var.enable_aws_managed_common_rule_set, "enabled", false) ? [0] : []
    content {
      name     = "aws-managed-common-rule-set"
      priority = var.enable_aws_managed_common_rule_set["priority"]

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesCommonRuleSet"
          vendor_name = "AWS"
        }
      }

      dynamic "visibility_config" {
        for_each = var.enable_aws_managed_common_rule_set["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.rule_group_name}-aws-managed-common-rule-set-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  dynamic "rule" {
    for_each = lookup(var.enable_aws_known_bad_input_rule_set, "enabled", false) ? [0] : []
    content {
      name     = "aws-known-bad-input-rule-set"
      priority = var.enable_aws_known_bad_input_rule_set["priority"]

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesKnownBadInputsRuleSet"
          vendor_name = "AWS"
        }
      }

      dynamic "visibility_config" {
        for_each = var.enable_aws_known_bad_input_rule_set["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.rule_group_name}-aws-known-bad-input-rule-set-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  dynamic "rule" {
    for_each = lookup(var.enable_aws_ip_reputation_rule_set, "enabled", false) ? [0] : []
    content {
      name     = "aws-ip-reputation-rule-set"
      priority = var.enable_aws_ip_reputation_rule_set["priority"]

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesAmazonIpReputationList"
          vendor_name = "AWS"
        }
      }

      dynamic "visibility_config" {
        for_each = var.enable_aws_ip_reputation_rule_set["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.rule_group_name}-aws-ip-reputation-rule-set-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  dynamic "rule" {
    for_each = lookup(var.enable_aws_sql_injection_rule_set, "enabled", false) ? [0] : []
    content {
      name     = "aws-sql-injection-rule-set"
      priority = var.enable_aws_sql_injection_rule_set["priority"]

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesSQLiRuleSet"
          vendor_name = "AWS"
        }
      }

      dynamic "visibility_config" {
        for_each = var.enable_aws_sql_injection_rule_set["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.rule_group_name}-aws-sql-injection-rule-set-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  dynamic "rule" {
    for_each = lookup(var.enable_aws_linux_rule_set, "enabled", false) ? [0] : []
    content {
      name     = "aws-linux-rule-set"
      priority = var.enable_aws_linux_rule_set["priority"]

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesLinuxRuleSet"
          vendor_name = "AWS"
        }
      }

      dynamic "visibility_config" {
        for_each = var.enable_aws_linux_rule_set["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.rule_group_name}-aws-linux-rule-set-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  dynamic "rule" {
    for_each = lookup(var.enable_aws_windows_rule_set, "enabled", false) ? [0] : []
    content {
      name     = "aws-windows-rule-set"
      priority = var.enable_aws_windows_rule_set["priority"]

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesWindowsRuleSet"
          vendor_name = "AWS"
        }
      }

      dynamic "visibility_config" {
        for_each = var.enable_aws_windows_rule_set["enable_cw_metrics"] ? [0] : []
        content {
          cloudwatch_metrics_enabled = true
          metric_name                = "${var.rule_group_name}-aws-windows-rule-set-rule-waf"
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
