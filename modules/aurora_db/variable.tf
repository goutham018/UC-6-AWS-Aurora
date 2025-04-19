variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The security group IDs for the database"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The subnet group name for the database"
  type        = string
}
