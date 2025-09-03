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
# Atualiza o sistema e instala Nginx e AWS CLI
yum update -y
amazon-linux-extras install -y nginx1
yum install -y awscli
systemctl enable nginx
systemctl start nginx

# Cria diretório para o site se não existir
mkdir -p /usr/share/nginx/html

# Sincroniza arquivos do S3 para a EC2
aws s3 sync s3://copaerp-orders-ui-bucket /usr/share/nginx/html

# Configura Nginx para servir React SPA
cat > /etc/nginx/conf.d/react.conf <<EOC
server {
    listen 80;
    server_name orders.copaerp.site;

    root /usr/share/nginx/html;
    index index.html index.htm;

    location / {
        try_files \$uri /index.html;
    }
}
EOC

# Reinicia Nginx
systemctl restart nginx

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
