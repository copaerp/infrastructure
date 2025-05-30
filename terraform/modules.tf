module "n8n" {
  source        = "./modules/n8n"
  ami_id        = var.ami_id
  key_name      = var.key_name
  iam_role_name = var.iam_role_name
}

module "route53" {
  source         = "./modules/route53"
  n8n_elastic_ip = module.n8n.n8n_elastic_ip
}

module "orders-db" {
  source = "./modules/orders-db"
}

module "orders" {
  source                   = "./modules/orders"
  route53_zone_id          = module.route53.copaerp_site_zone_id
  orders_db_connection_url = module.orders-db.orders_db_connection_url
  iam_role_id              = data.aws_iam_role.existing_role.arn
}

module "data" {
  source      = "./modules/data"
  iam_role_id = data.aws_iam_role.existing_role.arn
}
