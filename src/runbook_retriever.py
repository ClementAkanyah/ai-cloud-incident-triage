
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
RUNBOOK_DIR = BASE_DIR / "runbooks"

# Explicit mapping of incident types to approved runbooks
RUNBOOK_MAPPING = {
    "UnauthorizedAccess:IAMUser/ConsoleLoginSuccess.B":
        "iam_credential_compromise.md"
}


def retrieve_runbook(incident):
    """Retrieve an approved runbook for a supported incident type."""

    event_type = incident.get("event_type", "")
    runbook_name = RUNBOOK_MAPPING.get(event_type)

    if not runbook_name:
        raise ValueError(
            f"No approved runbook found for event type: {event_type}"
        )

    runbook_path = RUNBOOK_DIR / runbook_name

    if not runbook_path.is_file():
        raise FileNotFoundError(
            f"Runbook file not found: {runbook_name}"
        )

    return runbook_path.read_text(encoding="utf-8")


if __name__ == "__main__":
    from incident_processor import INCIDENT_FILE, load_incident

    incident = load_incident(INCIDENT_FILE)
    runbook = retrieve_runbook(incident)

    print("\n=== RUNBOOK RETRIEVAL ===")
    print(f"Incident: {incident['title']}")
    print(f"Event Type: {incident['event_type']}")
    print("\nRetrieved Runbook:")
    print(runbook)
