
# IAM Credential Compromise Response Runbook

## Purpose
Provide investigation and containment guidance for suspected
compromise or unauthorized use of AWS IAM credentials.

## Applicable Incidents
- Unusual IAM console login activity
- Suspicious use of IAM access keys
- Authentication activity from unexpected locations
- Multiple failed login attempts followed by success
- Unexpected privileged API activity

## Initial Investigation
1. Identify the affected IAM user or role.
2. Review relevant AWS CloudTrail events.
3. Examine source IP addresses, timestamps, and user agents.
4. Check whether MFA was used.
5. Review activity following the suspicious authentication.
6. Determine whether the activity was authorized.
7. Correlate related GuardDuty or Security Hub findings.

## Recommended Containment
If unauthorized access is confirmed or strongly suspected:

1. Escalate to the designated incident responder.
2. Review affected credentials and active sessions.
3. Consider disabling or rotating compromised credentials.
4. Consider restricting access to affected resources.
5. Preserve relevant evidence before making changes where feasible.

## Human Approval Requirements
- The AI platform must not independently disable IAM users.
- The AI platform must not revoke credentials automatically.
- The AI platform must not modify IAM permissions autonomously.
- A designated human responder must approve consequential
  containment actions.

## Recovery and Follow-Up
1. Reset or rotate affected credentials as appropriate.
2. Enforce MFA where applicable.
3. Review IAM permissions for excessive access.
4. Investigate possible unauthorized resource activity.
5. Document the incident and lessons learned.

## Evidence to Preserve
- Relevant CloudTrail event records
- GuardDuty or Security Hub findings
- Authentication timestamps
- Source IP addresses
- Affected IAM identities
- Relevant resource and API activity
