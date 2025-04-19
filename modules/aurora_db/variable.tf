variable "project_name" {
  type        = string
  description = "A unique name for the project"
}

variable "region" {
  type        = string
  description = "AWS region to deploy to"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones for subnets"
}

variable "database_name" {
  type        = string
  description = "The initial database name"
}

variable "db_engine" {
  type        = string
  description = "The database engine type"
}

variable "db_engine_version" {
  type        = string
  description = "The database engine version"
}

variable "db_instance_type" {
  type        = string
  description = "The instance type for Aurora nodes"
}

variable "db_master_username" {
  type        = string
  description = "The master username for the Aurora cluster"
}

variable "db_master_password_length" {
  type        = number
  description = "Length of the generated master password"
}

variable "aurora_cluster_name" {
  type        = string
  description = "The name of the Aurora cluster"
}

variable "secrets_manager_secret_name" {
  type        = string
  description = "The name of the secret in AWS Secrets Manager"
}

variable "db_port" {
  type        = number
  description = "The port the database listens on"
}

variable "allowed_inbound_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the AuroraDB"
}