# sg

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.load_balancer](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group) | resource |
| [aws_security_group.wordpress](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_lb_traffic](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_wordpress_to_internet](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.extra_inbound_access](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.inbound_rule_mysql](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_5000_wordpress](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_9000_wordpress](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_traffic_to_lb_443_2](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_traffic_to_lb_80](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_traffic_to_wordpress_80](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_extra_cidr_blocks"></a> [add\_extra\_cidr\_blocks](#input\_add\_extra\_cidr\_blocks) | Controls if extra CIDR blocks should be added. | `bool` | `false` | no |
| <a name="input_deployment_prefix"></a> [deployment\_prefix](#input\_deployment\_prefix) | prefix | `string` | n/a | yes |
| <a name="input_extra_cidr_blocks"></a> [extra\_cidr\_blocks](#input\_extra\_cidr\_blocks) | Extra CIDR blocks to get access to database. | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_sg"></a> [lb\_sg](#output\_lb\_sg) | lb sg |
| <a name="output_mysql_sg"></a> [mysql\_sg](#output\_mysql\_sg) | mysql sg |
| <a name="output_wordpress_sg"></a> [wordpress\_sg](#output\_wordpress\_sg) | wordpress sg |
<!-- END_TF_DOCS -->
