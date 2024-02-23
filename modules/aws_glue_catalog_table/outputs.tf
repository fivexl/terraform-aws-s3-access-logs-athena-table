output "arn" {
  description = "The ARN of the table."
  value       = aws_glue_catalog_table.this.arn
}

output "id" {
  description = "Catalog ID, Database name and of the name table."
  value       = aws_glue_catalog_table.this.id
}

# output "iam_policy_arn" {
#   description = "The ARN of the IAM policy to access this table."
#   value       = module.glue_table_iam_policy.arn
# }

output "catalog_id" {
  value = local.catalog_id
}

output "database_name" {
  description = "Name of the metadata database where the table metadata resides."
  value = local.database_name
}

output "table_name" {
  description = "Name of the table."
  value = local.table_name
}