output "efs_id" {
  value = aws_efs_file_system.eks-efs.id
}

output "rds_endpoint" {
  value = aws_db_instance.wordpress-rds.endpoint
}
