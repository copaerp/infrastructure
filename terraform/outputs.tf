output "n8n_elastic_ip" {
  description = "The Elastic IP address assigned to the n8n instance"
  value       = module.n8n.n8n_elastic_ip
}

output "n8n_domain" {
  description = "The fully qualified domain name for the n8n application"
  value       = module.route53.n8n_domain
}

output "copa_erp_site_name_servers" {
  description = "The name servers for the copa-erp.site domain"
  value       = module.route53.copa_erp_site_name_servers
}

output "copaerp_site_name_servers" {
  description = "The name servers for the copaerp.site domain"
  value       = module.route53.copaerp_site_name_servers
}

output "n8n_subdomain" {
  description = "The subdomain portion for the n8n application"
  value       = module.route53.n8n_subdomain
}

output "parameter_store_paths" {
  description = "AWS Parameter Store paths for domains"
  value       = module.route53.parameter_store_paths
}

output "copa_erp_site_ns_formatted" {
  description = "Formatted name servers for copa-erp.site (copy these values to your domain registrar)"
  value       = join("\n", module.route53.copa_erp_site_name_servers)
}

output "copaerp_site_ns_formatted" {
  description = "Formatted name servers for copaerp.site (copy these values to your domain registrar)"
  value       = join("\n", module.route53.copaerp_site_name_servers)
}
