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
  source               = "./modules/orders"
  route53_main_zone_id = module.route53.copaerp_main_zone_id
  route53_zone_id      = module.route53.copaerp_site_zone_id
  orders_db_username   = module.orders-db.orders_db_username
  orders_db_password   = module.orders-db.orders_db_password
  orders_db_endpoint   = module.orders-db.orders_db_endpoint
  orders_db_name       = module.orders-db.orders_db_name
  iam_role_id          = data.aws_iam_role.existing_role.arn
  account_id           = var.account_id
}

module "data" {
  source      = "./modules/data"
  iam_role_id = data.aws_iam_role.existing_role.arn
}

module "ecr" {
  source = "./modules/ecr"
}
