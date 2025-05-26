# Infraestrutura RDS PostgreSQL com Terraform

Este projeto contém a infraestrutura como código (IaC) para criar uma instância RDS PostgreSQL na AWS usando Terraform.

## Estrutura do Projeto

```
.
├── .github/
│   └── workflows/
│       └── terraform.yml    # Pipeline de CI/CD
├── main.tf                  # Configuração principal do RDS
├── variables.tf            # Definição das variáveis
├── backend.tf              # Configuração do backend S3
└── README.md              # Este arquivo
```

## Pré-requisitos

- Terraform >= 1.8.3
- Conta AWS com permissões adequadas
- Bucket S3 para armazenar o estado do Terraform
- Tabela DynamoDB para lock do estado
- VPC existente na AWS
- Security Group existente na AWS

## Variáveis Necessárias

O projeto requer as seguintes variáveis de ambiente/secrets:

- `VPC_ID`: ID da VPC onde o RDS será criado 
- `DB_USERNAME`: Nome de usuário para o banco de dados
- `DB_PASSWORD`: Senha do banco de dados
- `DB_NAME`: Nome do banco de dados
- `VPC_SECURITY_GROUP_IDS`: Lista de IDs dos security groups
- `DB_SUBNET_GROUP_NAME`: Nome do subnet group (opcional, padrão: "fastfood-subnet-group")
- `TERRAFORM_BUCKET`: Nome do bucket S3 para armazenar o estado

## Configuração do Backend

O estado do Terraform é armazenado em um bucket S3 com lock usando DynamoDB. Para configurar localmente:

1. Crie um arquivo `backend.hcl`:
```hcl
bucket         = "seu-bucket-terraform"
dynamodb_table = "terraform-cicd-lock"
region         = "us-east-1"
key            = "rds"
```

2. Inicialize o Terraform:
```bash
terraform init -backend-config=backend.hcl
```

## Recursos Criados

- Instância RDS PostgreSQL
- Subnet Group (se não existir)
- Configurações de segurança e rede

## Especificações do RDS

- Engine: PostgreSQL 17.4
- Instance Class: db.t3.micro
- Storage: 20GB
- Publicly Accessible: Sim
- Skip Final Snapshot: Sim

## CI/CD

O projeto utiliza GitHub Actions para automatizar o deploy. O pipeline:

1. Configura o ambiente Terraform
2. Configura as credenciais AWS
3. Inicializa o Terraform
4. Valida a configuração
5. Aplica as mudanças

## Segurança

- Credenciais sensíveis são armazenadas como secrets no GitHub
- O estado do Terraform é armazenado de forma segura no S3
- Lock do estado é gerenciado via DynamoDB

## Desenvolvimento Local

1. Clone o repositório
2. Configure as variáveis de ambiente necessárias
3. Crie o arquivo `backend.hcl` com suas configurações
4. Execute:
```bash
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## Limpeza

Para destruir a infraestrutura:

```bash
terraform destroy
```

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Crie um Pull Request
