# Hosted zone for copa-erp.site
resource "aws_route53_zone" "copa_erp_site" {
  name = "copa-erp.site"
  
  tags = {
    Name        = "copa-erp-site-zone"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

# Hosted zone for copaerp.site
resource "aws_route53_zone" "copaerp_site" {
  name = "copaerp.site"
  
  tags = {
    Name        = "copaerp-site-zone"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

# A record for n8n.copaerp.site pointing to the n8n EC2 instance
resource "aws_route53_record" "n8n_copaerp_site" {
  zone_id = aws_route53_zone.copaerp_site.zone_id
  name    = "n8n.copaerp.site"
  type    = "A"
  ttl     = "300"
  records = [var.n8n_elastic_ip]
}

# Store the n8n full domain in AWS Parameter Store
resource "aws_ssm_parameter" "n8n_domain_parameter" {
  name  = "/copa-erp/domains/n8n"
  type  = "String"
  value = "n8n.copaerp.site"
  
  tags = {
    Name        = "n8n-domain-parameter"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

# Store the n8n subdomain in AWS Parameter Store
resource "aws_ssm_parameter" "n8n_subdomain_parameter" {
  name  = "/copa-erp/domains/n8n-subdomain"
  type  = "String"
  value = "n8n"
  
  tags = {
    Name        = "n8n-subdomain-parameter"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

output "copa_erp_site_name_servers" {
  description = "Name servers for the copa-erp.site domain"
  value       = aws_route53_zone.copa_erp_site.name_servers
}

output "copaerp_site_name_servers" {
  description = "Name servers for the copaerp.site domain"
  value       = aws_route53_zone.copaerp_site.name_servers
}

output "n8n_domain" {
  description = "Domain for the n8n application"
  value       = aws_route53_record.n8n_copaerp_site.fqdn
}

output "n8n_subdomain" {
  description = "Subdomain for the n8n application"
  value       = "n8n"
}

output "parameter_store_paths" {
  description = "AWS Parameter Store paths created by this module"
  value = {
    n8n_domain     = aws_ssm_parameter.n8n_domain_parameter.name
    n8n_subdomain  = aws_ssm_parameter.n8n_subdomain_parameter.name
  }
}
