resource "random_id" "vpc_name_suffix" {
  byte_length = 8
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc-${random_id.vpc_name_suffix.hex}"
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 0)
  availability_zone = element(var.availability_zones, 0)

  tags = {
    Name        = "${var.project_name}-private-a"
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = element(var.availability_zones, 1)

  tags = {
    Name        = "${var.project_name}-private-b"
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_subnet" "private_c" {
  count             = length(var.availability_zones) > 2 ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone = element(var.availability_zones, 2)

  tags = {
    Name        = "${var.project_name}-private-c"
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  count          = length(var.availability_zones) > 2 ? 1 : 0
  subnet_id      = aws_subnet.private_c[0].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "aurora" {
  name_prefix = "${var.aurora_cluster_name}-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_inbound_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.aurora_cluster_name}-sg"
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.aurora_cluster_name}-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id, element(concat(aws_subnet.private_c.*.id, [""]), 0)]
}

resource "random_password" "db_master_password" {
  length           = var.db_master_password_length
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "aurora_credentials" {
  name = var.secrets_manager_secret_name
}

resource "aws_secretsmanager_secret_version" "aurora_credentials_version" {
  secret_id     = aws_secretsmanager_secret.aurora_credentials.id
  secret_string = jsonencode({
    username = var.db_master_username
    password = random_password.db_master_password.result
  })
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier   = var.aurora_cluster_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  database_name        = var.database_name
  master_username      = var.db_master_username
  master_password      = random_password.db_master_password.result # Initial password
  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name = aws_db_subnet_group.aurora.name
  skip_final_snapshot  = true
  manage_master_user_password = false # Managed by Secrets Manager
}

resource "aws_rds_cluster_instance" "instance_1" {
  cluster_identifier   = aws_rds_cluster.aurora.id
  instance_class       = var.db_instance_type
  engine               = var.db_engine
  engine_version       = var.db_engine_version
}

resource "aws_rds_cluster_instance" "instance_2" {
  cluster_identifier   = aws_rds_cluster.aurora.id
  instance_class       = var.db_instance_type
  engine               = var.db_engine
  engine_version       = var.db_engine_version
}