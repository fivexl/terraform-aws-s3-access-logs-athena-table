output "aws_glue_catalog_table_arn" {
  description = "The ARN of the Glue Table."
  value       = aws_glue_catalog_table.this.arn
}

output "aws_glue_catalog_table_id" {
  description = "The ID of the Glue Table."
  value       = aws_glue_catalog_table.this.id
}
