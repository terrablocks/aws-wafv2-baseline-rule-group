module "wafv2_rule_group" {
  source = "github.com/terrablocks/aws-wafv2-base-rule-group.git?ref=" # Always use `ref` to point module to a specific version or hash

  name = "baseline-waf-rule-group"
  scope = "REGIONAL"
}
