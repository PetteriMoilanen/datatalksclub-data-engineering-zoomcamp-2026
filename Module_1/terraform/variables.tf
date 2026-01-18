variable "credentials_file" {
  description = "GCP key json file"
  default     = "../api_keys/key.json"
  type        = string
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region for resources"
  default     = "europe-north1"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique GCS bucket name"
  type        = string
}

variable "bq_dataset_id" {
  description = "The unique ID for the BigQuery dataset"
  type        = string
}