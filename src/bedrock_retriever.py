
import boto3


KNOWLEDGE_BASE_ID = "HEXJXL91LG"
AWS_REGION = "us-east-2"


def retrieve_runbook_guidance(query: str, max_results: int = 3) -> list[dict]:
    """Retrieve relevant runbook passages from Bedrock Knowledge Bases."""

    if not query.strip():
        raise ValueError("The retrieval query cannot be empty.")

    client = boto3.client(
        "bedrock-agent-runtime",
        region_name=AWS_REGION,
    )

    response = client.retrieve(
        knowledgeBaseId=KNOWLEDGE_BASE_ID,
        retrievalQuery={"text": query},
        retrievalConfiguration={
            "vectorSearchConfiguration": {
                "numberOfResults": max_results
            }
        },
    )

    results = []

    for item in response.get("retrievalResults", []):
        results.append(
            {
                "text": item.get("content", {}).get("text", ""),
                "score": item.get("score"),
                "location": item.get("location", {}),
            }
        )

    return results


if __name__ == "__main__":
    question = (
        "What should an analyst investigate when an IAM user "
        "has suspicious console login activity without MFA?"
    )

    passages = retrieve_runbook_guidance(question)

    print("BEDROCK KNOWLEDGE BASE RETRIEVAL")
    print("=" * 45)

    for number, passage in enumerate(passages, start=1):
        print(f"\nPassage {number}")
        print(f"Similarity score: {passage['score']}")
        print(f"Text: {passage['text']}")
