
resource "aws_s3vectors_vector_bucket" "runbook_vectors" {
  vector_bucket_name = "ai-incident-triage-vectors"
}

resource "aws_s3vectors_index" "runbook_index" {
  index_name         = "incident-runbooks-index"
  vector_bucket_name = aws_s3vectors_vector_bucket.runbook_vectors.vector_bucket_name

  data_type = "float32"
  dimension = 1024

  distance_metric = "cosine"
}
