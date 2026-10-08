
from incident_processor import INCIDENT_FILE, load_incident
from runbook_retriever import retrieve_runbook


def main():
    try:
        # Step 1: Load and validate the security incident
        incident = load_incident(INCIDENT_FILE)

        print("\n=== AI CLOUD INCIDENT TRIAGE PLATFORM ===")
        print(f"Incident ID: {incident['incident_id']}")
        print(f"Title: {incident['title']}")
        print(f"Severity: {incident['severity']}")

        # Step 2: Retrieve the appropriate response runbook
        runbook = retrieve_runbook(incident)

        print("\n[1] Incident successfully loaded and validated.")
        print("[2] Approved incident-response runbook retrieved.")

        # Step 3: Prepare context for future Bedrock analysis
        context = {
            "incident": incident,
            "runbook": runbook
        }

        print("\n[3] Incident context prepared successfully.")
        print(f"Runbook content length: {len(context['runbook'])} characters")

        print("\nStatus: READY FOR BEDROCK INTEGRATION")

    except (FileNotFoundError, ValueError) as error:
        print(f"\nApplication error: {error}")


if __name__ == "__main__":
    main()
