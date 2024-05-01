# terraform-base-template

This is a template repository that will serve as a starting point for all the new terraform modules

## Important changes:
- Replace `REPO_NAME` with the actual repository name in examples and .tf-header.md
- Update module name in the examples
- Add title in the .tf-header.tf file

<!-- BEGIN_TF_DOCS -->
# Title

![License](https://img.shields.io/github/license/terrablocks/REPO_NAME?style=for-the-badge) ![Tests](https://img.shields.io/github/actions/workflow/status/terrablocks/REPO_NAME/tests.yml?branch=main&label=Test&style=for-the-badge) ![Checkov](https://img.shields.io/github/actions/workflow/status/terrablocks/REPO_NAME/checkov.yml?branch=main&label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/REPO_NAME?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/REPO_NAME?style=for-the-badge)

This terraform module will deploy the following services:

# Usage Instructions
## Example
```hcl
module "name" {
  source = "github.com/terrablocks/aws-wafv2-base-rule-group.git?ref=" # Always use `ref` to point module to a specific version or hash
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
| block_sanctioned_countries | Blacklist countries sanctioned by the US | ```object({ enabled = bool priority = number countries_code = list(string) enable_cw_metrics = bool })``` | ```{ "countries_code": [ "CU", "IR", "KP", "RU", "SY" ], "enable_cw_metrics": true, "enabled": true, "priority": 0 }``` | no |
| rule_group_name | Name of the rule group | `string` | n/a | yes |
| rule_group_scope | Scope of the rule group. **Note:** Valid value is either **REGIONAL** or **CLOUDFRONT** | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
