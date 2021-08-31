# terraform-aws-fargate-cloudmap-public-ip

This terraform module catch ECS task event to grab the container public IP address and update CloudMap (Service discovery)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudmap\_instance\_id | Cloudmap instance ID | `string` | `"default"` | no |
| cloudmap\_service\_id | Cloudmap service ID | `string` | n/a | yes |
| ecs\_cluster\_arn | ECS cluster ARN | `string` | n/a | yes |
| ecs\_service\_name | ECS service name | `string` | n/a | yes |
| name | Name | `string` | n/a | yes |
| tags | Tags map | `map(string)` | `{}` | no |

## Outputs

No output.

