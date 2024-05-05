output "arn" {
  value       = aws_wafv2_rule_group.this.arn
  description = "ARN of the WAF rule group"
}

output "id" {
  value       = aws_wafv2_rule_group.this.id
  description = "ID of the WAF rule group"
}

output "capacity" {
  value       = local.rule_group_capacity
  description = "WCU (web ACL capacity units) required for the WAF rule group"
}
