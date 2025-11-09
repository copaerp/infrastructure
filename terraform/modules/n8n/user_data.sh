#!/bin/bash

if [ ! -f /var/log/first_boot_done ]; then

    yum update -y
    yum install -y docker git

    systemctl start docker
    systemctl enable docker

    usermod -aG docker ec2-user

    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    cat > /tmp/setup_env.sh <<'EOF'
#!/bin/bash

DOMAIN_NAME=$(aws ssm get-parameter --name "/copa-erp/domains/root" --query "Parameter.Value" --output text)
SUBDOMAIN=$(aws ssm get-parameter --name "/copa-erp/domains/n8n-subdomain" --query "Parameter.Value" --output text)

git clone https://github.com/copaerp/n8n.git && cd ./n8n/

echo "DOMAIN_NAME=$DOMAIN_NAME" >> .env
echo "SUBDOMAIN=$SUBDOMAIN" >> .env

docker volume create n8n_data
docker volume create traefik_data

docker-compose up -d
EOF

    chmod +x /tmp/setup_env.sh
    su - ec2-user -c "/tmp/setup_env.sh"

    touch /var/log/first_boot_done
fi
