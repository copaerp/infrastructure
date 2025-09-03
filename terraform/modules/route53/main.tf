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

resource "aws_route53_record" "n8n_copaerp_site" {
  zone_id = aws_route53_zone.copaerp_site.zone_id
  name    = "orders.copaerp.site"
  type    = "A"
  ttl     = "300"
  records = [var.n8n_elastic_ip]
}

output "copaerp_site_zone_id" {
  value = aws_route53_zone.copaerp_site.zone_id
}

output "copaerp_main_zone_id" {
  value = aws_route53_zone.copaerp_site.zone_id
}
