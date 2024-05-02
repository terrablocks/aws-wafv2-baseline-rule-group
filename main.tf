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
      lookup(var.block_load_balancer_default_domain, "enabled", false) ? [12] : [0],
      
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-crs
      lookup(var.enable_aws_managed_common_rule_set, "enabled", false) ? [700] : [0],
      
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html#aws-managed-rule-groups-baseline-known-bad-inputs
      lookup(var.enable_aws_known_bad_input_rule_set, "enabled", false) ? [200] : [0],
      
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-ip-rep.html#aws-managed-rule-groups-ip-rep-amazon
      lookup(var.enable_aws_ip_reputation_rule_set, "enabled", false) ? [25] : [0],
      
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-sql-db
      lookup(var.enable_aws_sql_injection_rule_set, "enabled", false) ? [200] : [0],
      
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-linux-os
      lookup(var.enable_aws_linux_rule_set, "enabled", false) ? [200] : [0],
      
      # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-use-case.html#aws-managed-rule-groups-use-case-windows-os
      lookup(var.enable_aws_windows_rule_set, "enabled", false) ? [200] : [0]
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
          metric_name                = "${var.name}-aws-managed-common-rule-set-rule-waf"
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
          metric_name                = "${var.name}-aws-known-bad-input-rule-set-rule-waf"
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
          metric_name                = "${var.name}-aws-ip-reputation-rule-set-rule-waf"
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
          metric_name                = "${var.name}-aws-sql-injection-rule-set-rule-waf"
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
          metric_name                = "${var.name}-aws-linux-rule-set-rule-waf"
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
          metric_name                = "${var.name}-aws-windows-rule-set-rule-waf"
          sampled_requests_enabled   = true
        }
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.enable_rule_group_cw_metrics
    metric_name                = "${var.name}-waf-rule-group"
    sampled_requests_enabled   = var.enable_rule_group_cw_metrics
  }

  tags = var.tags
}
