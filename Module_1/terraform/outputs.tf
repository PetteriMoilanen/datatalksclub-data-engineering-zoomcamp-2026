output "gcs_bucket_url" {
  value       = google_storage_bucket.my_bucket.url
  description = "The URI of the created GCS bucket"
}

output "bq_dataset_id" {
  value       = google_bigquery_dataset.my_dataset.dataset_id
  description = "The ID of the BigQuery dataset"
}