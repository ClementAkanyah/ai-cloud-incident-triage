
import json
from pathlib import Path

# Locate the project directory
BASE_DIR = Path(__file__).resolve().parent.parent

# Locate the sample security incident
INCIDENT_FILE = BASE_DIR / "sample_incidents" / "suspicious_iam_activity.json"


def load_incident(file_path):
    """Read and validate a security incident JSON file."""

    with open(file_path, "r", encoding="utf-8") as file:
        incident = json.load(file)

    required_fields = [
        "incident_id",
        "title",
        "source",
        "severity",
        "description",
        "evidence"
    ]

    for field in required_fields:
        if field not in incident:
            raise ValueError(f"Missing required field: {field}")

    if incident["severity"] not in ["LOW", "MEDIUM", "HIGH", "CRITICAL"]:
        raise ValueError("Invalid incident severity")

    if not isinstance(incident["evidence"], dict):
        raise ValueError("Incident evidence must be a JSON object")

    return incident


def main():
    try:
        incident = load_incident(INCIDENT_FILE)

        print("\n=== CLOUD SECURITY INCIDENT ===")
        print(f"Incident ID: {incident['incident_id']}")
        print(f"Title: {incident['title']}")
        print(f"Source: {incident['source']}")
        print(f"Severity: {incident['severity']}")
        print(f"Description: {incident['description']}")

        print("\nEvidence:")
        for key, value in incident["evidence"].items():
            print(f"  {key}: {value}")

        print("\nIncident loaded and validated successfully.")

    except (FileNotFoundError, json.JSONDecodeError, ValueError) as error:
        print(f"Error processing incident: {error}")


if __name__ == "__main__":
    main()
