# Infrastructure Orchestrator

## How to build and use the Infrastructure from Scratch

1. **Development Environment Setup**
   - Run this project in a DevContainer to simulate a Linux environment with all necessary libraries and isolated credentials

2. **AWS Credentials Configuration**
   - Add your AWS credentials to the `.aws.env` file
   - A template file `.aws.env.example` in the same directory is provided to show the required format
   - Note: If you're working in a study lab environment, credentials may change after each restart

3. **Infrastructure Initialization**
   - Execute the startup script: `./bootstrap-init.sh`

4. **CI/CD Setup**
   - Add the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` secrets to your repository to enable CI/CD workflows

5. **Domain Configuration**
   - After deployment, update your domain registrar's settings with the name servers provided in the Terraform outputs
   - The following domains are configured:
     - `copa-erp.site`: Basic hosted zone with NS and SOA records
     - `copaerp.site`: Hosted zone with n8n application configured at `n8n.copaerp.site`

6. **Ready to Go**
   - The infrastructure is now ready for use. Just push something to `./terraform`

## Modules

The infrastructure is organized into the following modules:

1. **n8n**: Deploys an EC2 instance running the n8n workflow automation platform
2. **route53**: Manages DNS configurations for Copa ERP domains including hosted zones and records

## Outputs

After deployment, the following outputs are available:

- `n8n_elastic_ip`: The public IP address of the n8n instance
- `n8n_domain`: The fully qualified domain name for the n8n application
- `n8n_subdomain`: Just the subdomain portion for n8n (without the TLD)
- `copa_erp_site_name_servers`: Name servers for the copa-erp.site domain
- `copaerp_site_name_servers`: Name servers for the copaerp.site domain
- `copa_erp_site_ns_formatted` and `copaerp_site_ns_formatted`: Formatted name servers for easy copying
- `parameter_store_paths`: Paths to all stored parameters in AWS Parameter Store

## AWS Parameter Store

This infrastructure saves the following parameters to AWS Parameter Store:

- `/copa-erp/domains/root`: The root domain (copaerp.site)
- `/copa-erp/domains/n8n-subdomain`: Just the subdomain portion (n8n)

These parameters can be accessed by other applications or services that need to know the domain configuration.

## Integração Automática com n8n

O módulo n8n foi configurado para utilizar automaticamente os parâmetros do AWS Parameter Store:

1. Durante a inicialização da instância EC2, o script recupera os parâmetros do AWS Parameter Store
2. Os valores recuperados são adicionados ao arquivo `.env` no diretório `./n8n-local-container/src/`
3. Isso configura automaticamente o n8n com o domínio correto sem necessidade de intervenção manual
4. Os seguintes parâmetros são configurados no arquivo `.env`:
   - `DOMAIN_NAME`: Valor de `/copa-erp/domains/root` (copaerp.site)
   - `SUBDOMAIN`: Valor de `/copa-erp/domains/n8n-subdomain` (n8n)
