locals {
  id_split      = split(":", aws_glue_catalog_table.this.id)
  catalog_id    = local.id_split[0]
  database_name = local.id_split[1]
  table_name    = local.id_split[2]
}