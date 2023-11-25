# terraform-aws-s3-access-logs-athena-table
[![FivexL](https://releases.fivexl.io/fivexlbannergit.jpg)](https://fivexl.io/)

This Terraform module creates an AWS Glue table designed specifically to query Amazon S3 server access logs in the new [date-based partitioning](https://aws.amazon.com/about-aws/whats-new/2023/11/amazon-s3-server-access-logging-date-partitioning/) format [^1].

Date-based partitioning improves performance and cost-efficiency of downstream log processing systems by limiting the scanning of logs to only the desired time range.

## Usage
```hcl
module "s3_access_logs_glue_table" {
  source = "github.com/fivexl/terraform-aws-s3-access-logs-athena-table/?ref=main"

  name = "s3_server_access_logs"
  database_name = aws_glue_catalog_database.s3_access_logs_db.name
  location = "s3://${local.logging_bucket_name}/s3-server-access-logs"
}
```


## Links that may be useful
- [How do I enable log delivery?](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html#server-access-logging-overview)
- [Querying access logs for requests by using Amazon Athena](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-s3-access-logs-to-identify-requests.html#querying-s3-access-logs-for-requests)



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of AWS Glue database to create table in | `string` | n/a | yes |
| <a name="input_date_based_partitioning"></a> [date\_based\_partitioning](#input\_date\_based\_partitioning) | Whether to enable date-based partitioning | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | S3 location of S3 access logs. This is the same url you specify in the S3 bucket when you enable S3 server access logging - e.g. s3://my-bucket-name/s3-access-logs | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of AWS Glue table to create | `string` | `"s3_access_logs"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_glue_catalog_table_arn"></a> [aws\_glue\_catalog\_table\_arn](#output\_aws\_glue\_catalog\_table\_arn) | The ARN of the Glue Table. |
| <a name="output_aws_glue_catalog_table_id"></a> [aws\_glue\_catalog\_table\_id](#output\_aws\_glue\_catalog\_table\_id) | The ID of the Glue Table. |
<!-- END_TF_DOCS -->


---
[^1]: [Amazon S3 server access logging now supports automatic date-based partitioning](https://aws.amazon.com/about-aws/whats-new/2023/11/amazon-s3-server-access-logging-date-partitioning/)