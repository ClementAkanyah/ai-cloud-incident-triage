
resource "aws_bedrockagent_knowledge_base" "incident_runbooks" {
  name     = "ai-incident-triage-runbooks"
  role_arn = aws_iam_role.bedrock_knowledge_base.arn

  knowledge_base_configuration {
    type = "VECTOR"

    vector_knowledge_base_configuration {
      embedding_model_arn = "arn:${data.aws_partition.current.partition}:bedrock:us-east-2::foundation-model/amazon.titan-embed-text-v2:0"

      embedding_model_configuration {
        bedrock_embedding_model_configuration {
          dimensions = 1024
        }
      }
    }
  }

  storage_configuration {
    type = "S3_VECTORS"

    s3_vectors_configuration {
      index_arn = aws_s3vectors_index.runbook_index.index_arn
    }
  }

  tags = {
    Project = "AI Cloud Incident Triage"
    Purpose = "Incident response runbook retrieval"
  }

  depends_on = [
    aws_iam_role_policy.bedrock_runbook_access,
    aws_iam_role_policy.bedrock_embedding_access,
    aws_iam_role_policy.bedrock_vector_access
  ]
}
