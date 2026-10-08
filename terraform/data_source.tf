
# Connect the approved runbook S3 bucket
# to our Amazon Bedrock Knowledge Base.
resource "aws_bedrockagent_data_source" "incident_runbooks" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.incident_runbooks.id
  name              = "approved-incident-runbooks"

  data_source_configuration {
    type = "S3"

    s3_configuration {
      bucket_arn = aws_s3_bucket.runbooks.arn
    }
  }

  vector_ingestion_configuration {
    chunking_configuration {
      chunking_strategy = "FIXED_SIZE"

      fixed_size_chunking_configuration {
        max_tokens         = 300
        overlap_percentage = 10
      }
    }
  }
}
