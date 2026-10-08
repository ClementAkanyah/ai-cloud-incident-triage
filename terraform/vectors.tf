
# Vector bucket for incident-response runbook embeddings.
resource "aws_s3vectors_vector_bucket" "runbook_vectors" {
  vector_bucket_name = "ai-incident-triage-vectors"
}

# Vector index used by the Bedrock Knowledge Base.
resource "aws_s3vectors_index" "runbook_index" {
  index_name         = "incident-runbooks-index"
  vector_bucket_name = aws_s3vectors_vector_bucket.runbook_vectors.vector_bucket_name

  data_type       = "float32"
  dimension       = 1024
  distance_metric = "cosine"

  # Bedrock stores source text in this metadata field.
  # Keep it non-filterable to avoid the 2048-byte filterable
  # metadata limit.
  metadata_configuration {
    non_filterable_metadata_keys = [
      "AMAZON_BEDROCK_TEXT"
    ]
  }
}
