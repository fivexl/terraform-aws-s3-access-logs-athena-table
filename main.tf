locals {
  kebab_case_region = replace(data.aws_region.current.name, "-", "_") # kebab-case to snake_case
  glue_table_name = var.include_region_in_table_name ? "${var.name}_${local.kebab_case_region}" : var.name

  columns = [
    { name = "bucketowner", type = "string" },
    { name = "bucket_name", type = "string" },
    { name = "requestdatetime", type = "string" },
    { name = "remoteip", type = "string" },
    { name = "requester", type = "string" },
    { name = "requestid", type = "string" },
    { name = "operation", type = "string" },
    { name = "key", type = "string" },
    { name = "request_uri", type = "string" },
    { name = "httpstatus", type = "string" },
    { name = "errorcode", type = "string" },
    { name = "bytessent", type = "bigint" },
    { name = "objectsize", type = "bigint" },
    { name = "totaltime", type = "string" },
    { name = "turnaroundtime", type = "string" },
    { name = "referrer", type = "string" },
    { name = "useragent", type = "string" },
    { name = "versionid", type = "string" },
    { name = "hostid", type = "string" },
    { name = "sigv", type = "string" },
    { name = "ciphersuite", type = "string" },
    { name = "authtype", type = "string" },
    { name = "endpoint", type = "string" },
    { name = "tlsversion", type = "string" }
  ]
  partition_keys = var.date_based_partitioning ? [
    { name = "year", type = "string" },
    { name = "month", type = "string" },
    { name = "day", type = "string" },
    { name = "accountid", type = "string" },
    { name = "region", type = "string" },
    { name = "bucket", type = "string" }
  ] : []

  parameters = {
    "EXTERNAL" = "TRUE"
  }

  projection_parameters = {
    "projection.enabled" = "true",

    "projection.accountid.type" = "injected",
    "projection.region.type"    = "injected",
    "projection.bucket.type"    = "injected",

    "projection.year.type"     = "date",
    "projection.year.format"   = "yyyy",
    "projection.year.range"    = "2022,NOW",
    "projection.year.interval" = "1",

    "projection.month.type"   = "integer",
    "projection.month.range"  = "01,12",
    "projection.month.digits" = "2",

    "projection.day.type"   = "integer",
    "projection.day.range"  = "01,31",
    "projection.day.digits" = "2",

    "storage.location.template" = "${var.location}/$${accountid}/$${region}/$${bucket}/$${year}/$${month}/$${day}/"
  }
}

module "table"{
    source = "./modules/aws_glue_catalog_table"

    name = local.glue_table_name
    database_name = var.database_name
    owner = "hadoop"
    table_type = "EXTERNAL_TABLE"

    parameters = merge(
      local.parameters,
      var.date_based_partitioning ? local.projection_parameters : {}
    )
    partition_keys = local.partition_keys
    storage_descriptor = {
        columns = local.columns,
        location = var.location,
        input_format = "org.apache.hadoop.mapred.TextInputFormat",
        output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat",
        compressed = false,
        number_of_buckets = -1,
        ser_de_info = {
            serialization_library = "org.apache.hadoop.hive.serde2.RegexSerDe",
            parameters = {
                "serialization.format": "1",
                "input.regex": "([^ ]*) ([^ ]*) \\[(.*?)\\] ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) (\"[^\"]*\"|-) (-|[0-9]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) (\"[^\"]*\"|-) ([^ ]*)(?: ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*))?.*$"
            }
        },
    }
}