
data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# Allow Amazon Bedrock to assume this role for Knowledge Bases
# in our AWS account.
data "aws_iam_policy_document" "bedrock_assume_role" {
  statement {
    sid     = "AllowBedrockKnowledgeBase"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:${data.aws_partition.current.partition}:bedrock:us-east-2:${data.aws_caller_identity.current.account_id}:knowledge-base/*"
      ]
    }
  }
}

# Dedicated IAM role for the Bedrock Knowledge Base.
resource "aws_iam_role" "bedrock_knowledge_base" {
  name               = "ai-incident-triage-bedrock-kb-role"
  assume_role_policy = data.aws_iam_policy_document.bedrock_assume_role.json

  tags = {
    Project = "AI Cloud Incident Triage"
    Purpose = "Bedrock Knowledge Base service role"
  }
}

# Read-only access to approved incident response runbooks.
data "aws_iam_policy_document" "bedrock_runbook_access" {
  statement {
    sid     = "ReadApprovedRunbooks"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.runbooks.arn}/*"
    ]
  }

  statement {
    sid     = "CheckRunbookBucket"
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = [
      aws_s3_bucket.runbooks.arn
    ]
  }
}

resource "aws_iam_role_policy" "bedrock_runbook_access" {
  name   = "bedrock-approved-runbook-read-access"
  role   = aws_iam_role.bedrock_knowledge_base.id
  policy = data.aws_iam_policy_document.bedrock_runbook_access.json
}

# Allow only Amazon Titan Text Embeddings V2.
data "aws_iam_policy_document" "bedrock_embedding_access" {
  statement {
    sid     = "InvokeTitanEmbeddings"
    effect  = "Allow"
    actions = ["bedrock:InvokeModel"]

    resources = [
      "arn:${data.aws_partition.current.partition}:bedrock:us-east-2::foundation-model/amazon.titan-embed-text-v2:0"
    ]
  }
}

resource "aws_iam_role_policy" "bedrock_embedding_access" {
  name   = "bedrock-titan-embedding-access"
  role   = aws_iam_role.bedrock_knowledge_base.id
  policy = data.aws_iam_policy_document.bedrock_embedding_access.json
}

# Allow Bedrock to store and retrieve vectors in our index.
data "aws_iam_policy_document" "bedrock_vector_access" {
  statement {
    sid    = "AccessRunbookVectorIndex"
    effect = "Allow"

    actions = [
      "s3vectors:GetIndex",
      "s3vectors:QueryVectors",
      "s3vectors:PutVectors",
      "s3vectors:GetVectors",
      "s3vectors:DeleteVectors"
    ]

    resources = [
      aws_s3vectors_index.runbook_index.index_arn
    ]
  }
}

resource "aws_iam_role_policy" "bedrock_vector_access" {
  name   = "bedrock-runbook-vector-index-access"
  role   = aws_iam_role.bedrock_knowledge_base.id
  policy = data.aws_iam_policy_document.bedrock_vector_access.json
}
