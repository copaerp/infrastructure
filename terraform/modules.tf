module "n8n" {
  source              = "./modules/n8n"
  ami_id              = var.ami_id
  key_name            = var.key_name
  iam_role_id         = var.iam_role_id
  vpc_id              = aws_vpc.copa_vpc.id
  public_subnet_a_id  = aws_subnet.public_a.id
  private_subnet_a_id = aws_subnet.private_a.id
}

module "route53" {
  source         = "./modules/route53"
  n8n_elastic_ip = module.n8n.n8n_elastic_ip
}

module "orders" {
  source              = "./modules/orders"
  iam_role_id         = var.iam_role_id
  route53_zone_id     = module.route53.copaerp_site_zone_id
  vpc_id              = aws_vpc.copa_vpc.id
  public_subnet_a_id  = aws_subnet.public_a.id
  private_subnet_a_id = aws_subnet.private_a.id
}

module "orders-db" {
  source                = "./modules/orders-db"
  vpc_id                = aws_vpc.copa_vpc.id
  private_subnet_a_name = aws_subnet.private_a.name
}
