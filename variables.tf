variable "name" {
  description = "Name of AWS Glue table to create"
  type        = string
  default     = "s3_access_logs"
}

variable "database_name" {
  description = "Name of AWS Glue database to create table in"
  type        = string
}

variable "location" {
  description = "S3 location of S3 access logs. This is the same url you specify in the S3 bucket when you enable S3 server access logging - e.g. s3://my-bucket-name/s3-access-logs"
  type        = string
}

variable "date_based_partitioning" {
  description = "Whether to enable date-based partitioning"
  type        = bool
  default     = true
}
