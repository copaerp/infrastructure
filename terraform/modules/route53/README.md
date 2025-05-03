# Route53 Module

This module manages DNS configurations for Copa ERP domains.

## Features

- Creates hosted zones for both `copa-erp.site` and `copaerp.site` domains
- Configures an A record for `n8n.copaerp.site` pointing to the n8n EC2 instance
- Stores the n8n domain in AWS Parameter Store for reference by other services

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| n8n_elastic_ip | Elastic IP address of the n8n EC2 instance | string | yes |
| solution_name | Name of the solution, used for tagging and naming resources | string | yes |

## Outputs

| Name | Description |
|------|-------------|
| copa_erp_site_name_servers | Name servers for the copa-erp.site domain |
| copaerp_site_name_servers | Name servers for the copaerp.site domain |
| n8n_domain | Domain for the n8n application |

## Usage

```hcl
module "route53" {
  source         = "./modules/route53"
  n8n_elastic_ip = module.n8n.n8n_elastic_ip
  solution_name  = var.solution_name
}
```

## Important Note

After deploying this module, you will need to update your domain registrar's settings to point to the name servers provided by AWS Route53. You can find these name servers in the outputs of this module.
