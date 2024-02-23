variable "name" {
  description = "(Required) Name of the table. For Hive compatibility, this must be entirely lowercase."
  type        = string
}

variable "database_name" {
  description = "(Required) Name of the metadata database where the table metadata resides. For Hive compatibility, this must be all lowercase."
  type        = string
}

variable "catalog_id" {
  description = "(Optional) ID of the Glue Catalog and database to create the table in. If omitted, this defaults to the AWS Account ID plus the database name."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) Description of the table."
  type        = string
  default     = null
}

variable "owner" {
  description = "(Optional) Owner of the table."
  type        = string
  default     = null
}

variable "open_table_format_input" {
  description = "(Optional) Configuration block for open table formats. Note: A open_table_format_input cannot be added to an existing glue_catalog_table. This will destroy and recreate the table, possibly resulting in data loss."
  type = object({
    iceberg_input = object({
      metadata_operation = string
      version            = optional(string, "2")
    })
  })
  default = null
}

variable "parameters" {
  description = "(Optional) Properties associated with this table."
  type        = map(string)
  default     = null
}

variable "partition_index" {
  description = "(Optional) Configuration block for a maximum of 3 partition indexes."
  type = list(object({
    keys       = list(string)
    index_name = string
    })
  )
  default = null
}

variable "partition_keys" {
  description = "(Optional) Configuration block of columns by which the table is partitioned. Only primitive types are supported as partition keys."
  type = list(
    object({
      name    = string
      type    = optional(string)
      comment = optional(string)
    })
  )
  default = null
}

variable "retention" {
  description = "(Optional) Retention time for this table."
  type        = number
  default     = null
}

variable "table_type" {
  description = "(Optional) Type of this table (EXTERNAL_TABLE, VIRTUAL_VIEW, etc.). While optional, some Athena DDL queries such as ALTER TABLE and SHOW CREATE TABLE will fail if this argument is empty."
  type        = string
  default     = null
}

variable "target_table" {
  description = "(Optional) Configuration block of a target table for resource linking."
  type = object({
    catalog_id    = string
    database_name = string
    name          = string
  })
  default = null
}

variable "storage_descriptor" {
  description = "(Optional) Configuration block for information about the physical storage of this table. Columns types: https://docs.aws.amazon.com/athena/latest/ug/data-types.html. Columns types for iceberg: https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg-supported-data-types.html"
  type = object({
    bucket_columns = optional(list(string))
    columns = optional(list(object({
      name       = string
      comment    = optional(string)
      parameters = optional(map(string))
      type       = optional(string)
    })))
    compressed        = optional(bool)
    input_format      = optional(string)
    location          = optional(string)
    number_of_buckets = optional(number)
    output_format     = optional(string)
    parameters        = optional(map(string))

    ser_de_info = optional(object({
      name                  = optional(string)
      serialization_library = optional(string)
      parameters            = optional(map(string))
    }))

    schema_reference = optional(object({
      schema_version_number = optional(number)
      schema_version_id     = optional(string)
      schema_id = optional(object({
        registry_name = optional(string)
        schema_name   = optional(string)
        schema_arn    = optional(string)
      }))
    }))
  })
  default = null
}