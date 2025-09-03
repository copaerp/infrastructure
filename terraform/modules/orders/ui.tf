variable "domain_name" {
  default = "orders.copaerp.site"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "copaerp-orders-ui-bucket"

  tags = {
    Name = "copaerp-orders-ui-bucket"
  }
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

# ----------------------
# Route 53
# ----------------------
resource "aws_route53_record" "frontend" {
  zone_id = var.route53_main_zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [aws_s3_bucket_website_configuration.frontend.website_endpoint]
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

# resource "aws_instance" "nginx_ec2" {
#   ami                  = data.aws_ami.amazon_linux.id
#   key_name             = var.key_name
#   instance_type        = "t2.micro"
#   iam_instance_profile = aws_iam_instance_profile.nginx_ec2_instance_profile.name

#   security_groups = [aws_security_group.nginx_sg.name]

#   root_block_device {
#     volume_size = 20
#     volume_type = "gp2"
#   }

#   user_data = <<-EOF
# #!/bin/bash
# yum update -y
# amazon-linux-extras install -y nginx1
# systemctl enable nginx
# systemctl start nginx

# # Configura Nginx para fazer proxy para o bucket
# cat > /etc/nginx/conf.d/react.conf <<EOC
# server {
#     listen 80;
#     server_name orders.copaerp.site;

#     location / {
#         proxy_pass http://copaerp-orders-ui-bucket.s3-website-us-east-1.amazonaws.com/;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#     }
# }
# EOC

# systemctl restart nginx
#               EOF

#   tags = {
#     Name = "nginx-ec2"
#   }
# }

# output "ec2_public_ip" {
#   value = aws_instance.nginx_ec2.public_ip
# }
