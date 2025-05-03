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
