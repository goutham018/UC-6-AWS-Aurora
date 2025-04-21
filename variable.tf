variable "project_name" {
  type        = string
  description = "A unique name for the project"
  default     = "my-simple-aurora"
}

variable "region" {
  type        = string
  description = "AWS region to deploy to"
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones for subnets"
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "database_name" {
  type        = string
  description = "The initial database name"
  default     = "mydatabase"
}

variable "db_engine" {
  type        = string
  description = "The database engine type"
  default     = "aurora-mysql"
}

variable "db_engine_version" {
  type        = string
  description = "The database engine version"
  default     = "8.0.mysql_aurora.3.05.2"
}

variable "db_instance_type" {
  type        = string
  description = "The instance type for Aurora nodes"
  default     = "db.t4g.medium" # Try a compatible instance type
}

variable "db_master_username" {
  type        = string
  description = "The master username for the Aurora cluster"
  default     = "admin"
}

variable "db_master_password_length" {
  type        = number
  description = "Length of the generated master password"
  default     = 16
}

variable "aurora_cluster_name" {
  type        = string
  description = "The name of the Aurora cluster"
  default     = "my-aurora-cluster"
}

variable "secrets_manager_secret_name" {
  type        = string
  description = "The name of the secret in AWS Secrets Manager"
  default     = "aurora-master-credentials-v8" # Use a new unique name
}

variable "db_port" {
  type        = number
  description = "The port the database listens on"
  default     = 3306
}

variable "allowed_inbound_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the AuroraDB"
  default     = ["10.0.0.0/8"] # Adjust this to your network range for security
}
