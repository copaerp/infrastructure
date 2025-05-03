resource "aws_route53_zone" "copa_erp_site" {
  name = "copa-erp.site"

  tags = {
    Name        = "copa-erp-site-zone"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

resource "aws_route53_zone" "copaerp_site" {
  name = "copaerp.site"

  tags = {
    Name        = "copaerp-site-zone"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

resource "aws_route53_record" "n8n_copaerp_site" {
  zone_id = aws_route53_zone.copaerp_site.zone_id
  name    = "n8n.copaerp.site"
  type    = "A"
  ttl     = "300"
  records = [var.n8n_elastic_ip]
}

resource "aws_ssm_parameter" "root_domain_parameter" {
  name  = "/copa-erp/domains/root"
  type  = "String"
  value = "copaerp.site"

  tags = {
    Name        = "domain-parameter"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

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
