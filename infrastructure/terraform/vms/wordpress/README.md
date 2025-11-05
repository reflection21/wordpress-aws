# wordpress

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.wordpress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_prefix"></a> [deployment\_prefix](#input\_deployment\_prefix) | prefix | `string` | n/a | yes |
| <a name="input_wordpres_subnet_id"></a> [wordpres\_subnet\_id](#input\_wordpres\_subnet\_id) | private instance id | `list(string)` | n/a | yes |
| <a name="input_wordpress_profile"></a> [wordpress\_profile](#input\_wordpress\_profile) | private profile | `string` | n/a | yes |
| <a name="input_wordpress_sg"></a> [wordpress\_sg](#input\_wordpress\_sg) | private sg | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_wordpress_server_id"></a> [wordpress\_server\_id](#output\_wordpress\_server\_id) | wordpress server |
<!-- END_TF_DOCS -->
