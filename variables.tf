variable "vpc_id" {
  description = "ID da VPC onde o RDS será criado"
  type        = string
}

variable "db_username" {
  description = "Nome de usuário para o banco de dados RDS"
  type        = string
}

variable "db_password" {
  description = "Senha para o banco de dados RDS"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nome do banco de dados RDS"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Lista de IDs dos security groups para o RDS"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "Nome do subnet group existente para o RDS"
  type        = string
  default     = "fastfood-subnet-group"
} 