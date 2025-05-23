data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Buscar subnets existentes associadas à VPC
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

# Criar o subnet group
resource "aws_db_subnet_group" "fastfood" {
  name       = var.db_subnet_group_name
  subnet_ids = data.aws_subnets.selected.ids

  tags = {
    Name = "FastFood DB Subnet Group"
  }

  lifecycle {
    ignore_changes = [name]
  }
}

# Criar a instância do banco de dados PostgreSQL
resource "aws_db_instance" "fastfood" {
  identifier              = "fastfood-db"                       # nome único da instância RDS
  allocated_storage       = 20                                  # armazenamento mínimo do Free Tier
  engine                  = "postgres"                          # tipo de banco
  engine_version          = "17.4"                              # versão do PostgreSQL
  instance_class          = "db.t3.micro"                       # classe compatível com Free Tier
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name                         # nome do banco
  publicly_accessible     = true                                # permite acesso pela internet
  skip_final_snapshot     = true                                # não gera snapshot ao destruir
  vpc_security_group_ids  = var.vpc_security_group_ids         # SG EXISTENTE
  db_subnet_group_name    = var.db_subnet_group_name

  tags = {
    Name = "FastFood RDS"
  }
}
