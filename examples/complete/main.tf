locals {
  logging_bucket_name = "s3-access-logs"
}

resource "aws_glue_catalog_database" "s3_access_logs_db" {
  name = "s3_access_logs_db"
}

module "s3_access_logs_glue_table" {
  source = "./modules/s3-access-logs-glue-table"

  name          = "s3_server_access_logs"
  database_name = aws_glue_catalog_database.s3_access_logs_db.name
  location      = "s3://${local.logging_bucket_name}/s3-server-access-logs"
}


module "s3_access_logs_glue_table_unpartitioned" {
  source = "./modules/s3-access-logs-glue-table"

  name                    = "s3_access_logs"
  database_name           = aws_glue_catalog_database.s3_access_logs_db.name
  location                = "s3://${local.logging_bucket_name}/s3-access-logs"
  date_based_partitioning = false
}