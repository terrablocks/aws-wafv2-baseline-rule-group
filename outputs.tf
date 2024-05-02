output "arn" {
  value = aws_wafv2_rule_group.this.arn
}

output "id" {
  value = aws_wafv2_rule_group.this.id
}

output "capacity" {
  value = local.rule_group_capacity
}
