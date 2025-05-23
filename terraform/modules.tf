module "n8n" {
  source      = "./modules/n8n"
  ami_id      = var.ami_id
  key_name    = var.key_name
  iam_role_id = var.iam_role_id
}

module "route53" {
  source         = "./modules/route53"
  n8n_elastic_ip = module.n8n.n8n_elastic_ip
}

module "orders" {
  source          = "./modules/orders"
  iam_role_id     = var.iam_role_id
  route53_zone_id = module.route53.copaerp_site_zone_id
}

module "orders-db" {
  source = "./modules/orders-db"
}
