output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "private_subnet_ids" {
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id, element(concat(aws_subnet.private_c.*.id, [""]), 0)]
  description = "List of private subnet IDs"
}

output "security_group_id" {
  value       = aws_security_group.aurora.id
  description = "The ID of the Aurora security group"
}

output "aurora_cluster_endpoint" {
  value       = aws_rds_cluster.aurora.endpoint
  description = "The endpoint of the Aurora cluster"
}

output "aurora_cluster_reader_endpoint" {
  value       = aws_rds_cluster.aurora.reader_endpoint
  description = "The reader endpoint of the Aurora cluster"
}

output "aurora_master_username" {
  value       = aws_rds_cluster.aurora.master_username
  description = "The master username for the Aurora cluster"
}

output "secrets_manager_arn" {
  value       = aws_secretsmanager_secret.aurora_credentials.arn
  description = "The ARN of the Secrets Manager secret"
}