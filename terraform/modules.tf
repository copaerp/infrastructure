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

module "orders-db" {
  source = "./modules/orders-db"
}

module "orders" {
  source                   = "./modules/orders"
  iam_role_id              = var.iam_role_id
  route53_zone_id          = module.route53.copaerp_site_zone_id
  orders_db_connection_url = module.orders-db.orders_db_connection_url
}

module "s3_bronze" {
  source      = "./modules/data/s3_bucket"
  # environment = var.environment
}

module "kinesis_firehose" {
  source       = "./modules/data/kinesis"
  name         = "firehose-copa"
  iam_role_id  = data.aws_iam_role.existing_role.arn        
  bucket_arn   = "arn:aws:s3:::copa-general-bronze"
}
