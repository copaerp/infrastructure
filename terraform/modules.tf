module "n8n" {
  source      = "./modules/n8n"
  ami_id      = var.ami_id
  key_name    = var.key_name
  iam_role_id = var.iam_role_id
}

module "orders" {
  source      = "./modules/orders"
  iam_role_id = var.iam_role_id
}

module "route53" {
  source                            = "./modules/route53"
  n8n_elastic_ip                    = module.n8n.n8n_elastic_ip
  message_standardizer_api_endpoint = module.orders.message_standardizer_api_endpoint
}
