# vpc

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
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/nat_gateway) | resource |
| [aws_route_table.public_rt](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/route_table) | resource |
| [aws_route_table.wordpress_rt](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.wordpress](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/route_table_association) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/subnet) | resource |
| [aws_subnet.rds](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/subnet) | resource |
| [aws_subnet.wordpress](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/resources/vpc) | resource |
| [aws_availability_zones.az](https://registry.terraform.io/providers/hashicorp/aws/6.17.0/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_prefix"></a> [deployment\_prefix](#input\_deployment\_prefix) | prefix | `string` | n/a | yes |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | public subnet cidr | `list(string)` | n/a | yes |
| <a name="input_rds_subnet_cidr"></a> [rds\_subnet\_cidr](#input\_rds\_subnet\_cidr) | rds subnet cidr | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | vpc cidr | `string` | n/a | yes |
| <a name="input_wordpress_subnet_cidr"></a> [wordpress\_subnet\_cidr](#input\_wordpress\_subnet\_cidr) | wordpress subnet cidr | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | public subnet id |
| <a name="output_rds_subnet_id"></a> [rds\_subnet\_id](#output\_rds\_subnet\_id) | rds subnet id |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | vpc id |
| <a name="output_wordpress_subnet_id"></a> [wordpress\_subnet\_id](#output\_wordpress\_subnet\_id) | wordpress subnet id |
<!-- END_TF_DOCS -->
