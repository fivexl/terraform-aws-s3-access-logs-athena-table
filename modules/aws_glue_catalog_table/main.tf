resource "aws_glue_catalog_table" "this" {
  name          = var.name
  database_name = var.database_name

  catalog_id  = var.catalog_id
  description = var.description
  owner       = var.owner

  dynamic "open_table_format_input" {
    for_each = var.open_table_format_input != null ? [true] : []
    content {
      iceberg_input {
        metadata_operation = var.open_table_format_input.iceberg_input.metadata_operation
        version            = var.open_table_format_input.iceberg_input.version
      }
    }
  }

  parameters = var.parameters

  dynamic "partition_index" {
    for_each = var.partition_index != null ? var.partition_index : []
    content {
      keys       = partition_index.value.keys
      index_name = partition_index.value.index_name
    }
  }

  dynamic "partition_keys" {
    for_each = var.partition_keys != null ? var.partition_keys : []
    content {
      name    = partition_keys.value.name
      type    = partition_keys.value.type
      comment = partition_keys.value.comment
    }
  }

  retention = var.retention

  dynamic "storage_descriptor" {
    for_each = var.storage_descriptor != null ? [true] : []
    content {
      bucket_columns = var.storage_descriptor.bucket_columns
      dynamic "columns" {
        for_each = var.storage_descriptor.columns != null ? var.storage_descriptor.columns : []
        content {
          name       = columns.value.name
          comment    = columns.value.comment
          parameters = columns.value.parameters
          type       = columns.value.type
        }
      }

      compressed        = var.storage_descriptor.compressed
      input_format      = var.storage_descriptor.input_format
      location          = var.storage_descriptor.location
      number_of_buckets = var.storage_descriptor.number_of_buckets
      output_format     = var.storage_descriptor.output_format
      parameters        = var.storage_descriptor.parameters

      dynamic "ser_de_info" {
        for_each = var.storage_descriptor.ser_de_info != null ? [true] : []
        content {
          name                  = var.storage_descriptor.ser_de_info.name
          serialization_library = var.storage_descriptor.ser_de_info.serialization_library
          parameters            = var.storage_descriptor.ser_de_info.parameters
        }
      }

      dynamic "schema_reference" {
        for_each = var.storage_descriptor.schema_reference != null ? [true] : []
        content {
          schema_version_number = var.storage_descriptor.schema_reference.schema_version_number
          schema_version_id     = var.storage_descriptor.schema_reference.schema_version_id

          dynamic "schema_id" {
            for_each = var.storage_descriptor.schema_reference.schema_id != null ? [true] : []
            content {
              registry_name = var.storage_descriptor.schema_reference.schema_id.registry_name
              schema_name   = var.storage_descriptor.schema_reference.schema_id.schema_name
              schema_arn    = var.storage_descriptor.schema_reference.schema_id.schema_arn
            }
          }
        }
      }
    }
  }

  table_type = var.table_type

  dynamic "target_table" {
    for_each = var.target_table != null ? [true] : []
    content {
      catalog_id    = var.target_table.value.catalog_id
      database_name = var.target_table.value.database_name
      name          = var.target_table.value.name
    }
  }
}
