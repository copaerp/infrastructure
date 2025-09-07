variable "domain_name" {
  default = "orders.copaerp.site"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "copaerp-orders-ui-bucket"

  tags = {
    Name = "copaerp-orders-ui-bucket"
  }
}

# ----------------------
# Security Group para EC2
# ----------------------
resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ----------------------
# EC2 com Nginx apontando para S3
# ----------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_iam_instance_profile" "nginx_ec2_instance_profile" {
  name = "nginx_ec2-instance-profile"
  role = var.iam_role_name
}

resource "aws_instance" "nginx_ec2" {
  ami                  = data.aws_ami.amazon_linux.id
  key_name             = var.key_name
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.nginx_ec2_instance_profile.name

  security_groups = [aws_security_group.nginx_sg.name]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

user_data = <<-EOF
#!/bin/bash
yum update -y
amazon-linux-extras install -y nginx1 epel
yum install -y awscli certbot

systemctl enable nginx
systemctl start nginx

mkdir -p /usr/share/nginx/html

aws s3 sync s3://copaerp-orders-ui-bucket /usr/share/nginx/html

cat > /etc/nginx/conf.d/react.conf <<EOC
server {
    listen 80;
    server_name orders.copaerp.site;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }
}
EOC

systemctl restart nginx
sleep 10

systemctl stop nginx
certbot certonly --standalone -d orders.copaerp.site --non-interactive --agree-tos -m joaqu1m.pires@hotmail.com
systemctl start nginx

cat > /etc/nginx/conf.d/react.conf <<EOC
server {
    listen 80;
    server_name orders.copaerp.site;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name orders.copaerp.site;

    root /usr/share/nginx/html;
    index index.html;

    ssl_certificate /etc/letsencrypt/live/orders.copaerp.site/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/orders.copaerp.site/privkey.pem;

    location / {
        try_files \$uri /index.html;
    }
}
EOC

systemctl restart nginx

# --- Adição do Cronjob ---
cat > /etc/cron.d/s3_sync_nginx <<CRON_EOF
# Sincroniza o bucket S3 e reinicia o Nginx a cada 5 minutos
*/5 * * * * root aws s3 sync s3://copaerp-orders-ui-bucket /usr/share/nginx/html --delete && systemctl reload nginx > /dev/null 2>&1
CRON_EOF
# -------------------------

certbot renew --dry-run
              EOF

  tags = {
    Name        = "nginx-ec2"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

resource "aws_eip" "nginx_eip" {
  instance   = aws_instance.nginx_ec2.id
  depends_on = [aws_instance.nginx_ec2]
}

output "nginx_elastic_ip" {
  value = aws_eip.nginx_eip.public_ip
}
