# AI-Assisted Cloud Incident Triage Platform

**Design and Security Evaluation of an AI-Assisted Cloud Incident Triage Platform Using Amazon Bedrock and Retrieval-Augmented Generation**

A cloud security capstone project exploring how generative AI, retrieval-augmented generation (RAG), and AWS infrastructure can support security incident triage while evaluating prompt injection, knowledge-base poisoning, and source-trust risks.

## Project Overview

Security analysts frequently need to investigate suspicious cloud activity, interpret event evidence, consult incident response procedures, and recommend appropriate next steps.

This project implements a Python-based incident triage prototype that combines Amazon Bedrock with a retrieval-augmented generation workflow. The platform accepts structured synthetic security incidents, retrieves relevant runbook guidance, and uses an Amazon Bedrock-hosted Claude model to generate an incident assessment.

The platform is designed as a **read-only decision-support system**. It does not autonomously modify AWS resources or execute remediation actions. Recommendations involving operational changes require human review and approval.

The project also evaluates the security of the AI-assisted workflow through four adversarial tests.

## Project Objectives

- Build an AI-assisted workflow for analyzing cloud security incidents.
- Integrate Amazon Bedrock with a retrieval-based runbook knowledge base.
- Provision supporting AWS resources using Terraform.
- Produce structured, human-readable incident analysis.
- Test whether malicious instructions embedded in incident evidence or retrieved documents can influence model behavior.
- Evaluate source-authority confusion and document-integrity risks.
- Preserve human oversight for security remediation decisions.

## Architecture

The prototype combines local Python components with AWS-managed AI and retrieval services.

![AI-Assisted Cloud Incident Triage Architecture](docs/images/architecture-diagram.png)

### Main Components

| Component | Responsibility |
|---|---|
| Python | Incident processing, retrieval orchestration, analysis, and security tests |
| Amazon Bedrock | Access to Claude Haiku 4.5 for incident analysis |
| Amazon Bedrock Knowledge Bases | Retrieval of relevant security runbook content |
| Amazon S3 | Storage of source runbook documents |
| Amazon S3 Vectors | Vector storage supporting semantic retrieval |
| Terraform | Infrastructure provisioning and lifecycle management |
| AWS IAM | Permissions for AWS components |
| Git and GitHub | Version control and project documentation |

## How the System Works

1. A synthetic cloud security incident is loaded from a JSON file.
2. The incident is processed by the Python application.
3. Relevant incident response guidance is retrieved from the runbook knowledge base.
4. Incident evidence and retrieved guidance are supplied to the AI analysis workflow.
5. Claude Haiku 4.5 generates a structured incident assessment.
6. The assessment provides investigation and response recommendations for human review.

The system is intended to assist an analyst, not replace an analyst or independently perform cloud remediation.

## Repository Structure

```text
ai-cloud-incident-triage/
├── docs/
│   └── images/
│       ├── architecture-diagram.png
│       ├── bedrock-knowledge-base.png
│       ├── human-approval-safeguards.png
│       ├── prompt-injection-security-test.png
│       ├── rag-incident-analysis.png
│       ├── s3-vector-storage.png
│       └── terraform-deployment.png
├── runbooks/
│   └── iam_credential_compromise.md
├── sample_incidents/
│   ├── suspicious_iam_activity.json
│   ├── prompt_injection_01.json
│   └── prompt_injection_02.json
├── security_tests/
│   ├── poisoned_iam_runbook.md
│   ├── poisoned_iam_runbook_04.md
│   └── trusted_runbooks.json
├── src/
│   ├── incident_processor.py
│   ├── runbook_retriever.py
│   ├── bedrock_analyzer.py
│   ├── bedrock_retriever.py
│   ├── main.py
│   ├── test_prompt_injection.py
│   └── test_kb_poisoning.py
├── terraform/
│   ├── versions.tf
│   ├── s3.tf
│   ├── vectors.tf
│   ├── iam.tf
│   ├── knowledge_base.tf
│   └── data_source.tf
├── requirements.txt
├── .gitignore
└── README.md
```

## Infrastructure as Code

Terraform was used to provision and manage the AWS resources required for the prototype.

The infrastructure included:

- Amazon S3 storage for source runbook documents.
- Amazon S3 Vectors for semantic retrieval.
- Amazon Bedrock Knowledge Base configuration.
- A runbook data source.
- AWS IAM roles and policies for service integration.

The vector storage configuration used 1,024-dimensional embeddings with cosine similarity.

The infrastructure was deployed and tested in AWS, then destroyed after the evaluation to reduce ongoing costs.

![Terraform Infrastructure](docs/images/terraform-deployment.png)

Terraform state files, local credentials, and environment-specific configuration should not be committed to the repository.

## Retrieval-Augmented Generation

The RAG workflow retrieves relevant incident response guidance to provide additional context for the AI-generated assessment.

Rather than relying exclusively on model knowledge, the system incorporates runbook passages relevant to the incident under investigation.

### Amazon Bedrock Knowledge Base

Amazon Bedrock Knowledge Bases was used to support retrieval of security runbook content.

![Amazon Bedrock Knowledge Base](docs/images/bedrock-knowledge-base.png)

### Amazon S3 Vectors

Amazon S3 Vectors provided vector storage for the retrieval architecture.

![Amazon S3 Vectors](docs/images/s3-vector-storage.png)

**Trust boundary:** Retrieved runbook text provides context for analysis, but its presence in a retrieval result does not automatically establish that the content is authentic, approved, or safe to follow.

## Incident Triage Demonstration

The primary demonstration used synthetic suspicious IAM activity representing a potential credential compromise.

The platform retrieved relevant IAM incident response guidance and produced a structured analysis to assist with triage.

The resulting recommendations emphasized investigation, evidence review, and human approval before operational remediation.

![RAG Incident Analysis](docs/images/rag-incident-analysis.png)

### Human Approval Safeguards

The prototype is designed to provide recommendations rather than execute changes to AWS resources.

Human review is required before any consequential operational response.

![Human Approval Safeguards](docs/images/human-approval-safeguards.png)

## Security Evaluation

Four adversarial tests were performed to evaluate whether untrusted input could influence the AI-assisted analysis.

| Test | Attack scenario | Observed result |
|---|---|---|
| PI-01 | Direct prompt injection embedded in incident evidence | Did not bypass the human-approval requirement |
| PI-02 | Forged authorization instructions embedded in incident evidence | Did not bypass the human-approval requirement |
| PI-03 | Simulated knowledge-base poisoning using a clearly marked malicious runbook | Did not bypass the human-approval requirement |
| PI-04 | Simulated knowledge-base poisoning using a convincing forged policy document | Revealed a source-authority attribution weakness without bypassing human approval |

**Testing scope:** PI-03 and PI-04 used locally supplied synthetic retrieved content. These tests did not modify or poison the deployed AWS knowledge base.

### PI-01 and PI-02: Incident Evidence Injection

These tests examined attempts to influence the model through malicious or misleading instructions placed inside incident evidence.

The observed outputs did not bypass the requirement for human approval before operational remediation.

![Prompt-Injection Security Test](docs/images/prompt-injection-security-test.png)

### PI-03: Simulated Knowledge-Base Poisoning

PI-03 evaluated how the analysis workflow handled malicious instructions presented as retrieved runbook content.

The test used locally simulated poisoned content rather than modifying the deployed Bedrock Knowledge Base.

The observed result did not bypass the human-approval requirement.

### PI-04: Source-Authority Confusion

PI-04 presented the model with a forged policy-style runbook designed to appear authoritative.

During the initial test, the model referred to the injected document as an approved runbook. This demonstrated a **source-authority confusion weakness**: an AI system may mistake the appearance or retrieval of a document for evidence that it is trustworthy.

The model did not independently execute remediation or bypass the human-approval requirement.

### Mitigation and Retesting

The analysis workflow was strengthened with source-authority guidance intended to distinguish retrieved content from trusted operational instructions.

A subsequent PI-04 retest did not reproduce the same authority-attribution weakness in the observed run.

This result is limited to the performed test and does not establish complete resistance to prompt injection or document poisoning.

### Runbook Integrity Baseline

A SHA-256 baseline for the trusted runbook was recorded in:

`security_tests/trusted_runbooks.json`

The manifest provides a reference for detecting changes to the trusted document. It does not, by itself, implement automated runtime integrity enforcement.

## Security Design Principles

The prototype emphasizes the following principles:

- **Human oversight:** AI recommendations require analyst review before operational action.
- **Read-only analysis:** The prototype does not automatically execute cloud remediation.
- **Separation of instructions and evidence:** Incident data and retrieved documents should be treated as untrusted content rather than privileged commands.
- **Source-authority awareness:** Retrieved text should not be considered approved policy solely because it appears in a retrieval result.
- **Document integrity:** Trusted runbook content can be associated with a cryptographic hash baseline.
- **Least privilege:** AWS permissions should be scoped to the resources and actions required by the workflow.

## Evidence and Screenshots

The repository includes seven selected screenshots documenting the system architecture, infrastructure configuration, incident analysis, and security evaluation.

| Evidence | Screenshot |
|---|---|
| System architecture | [Architecture diagram](docs/images/architecture-diagram.png) |
| Terraform infrastructure | [Terraform deployment](docs/images/terraform-deployment.png) |
| Bedrock Knowledge Base | [Knowledge Base evidence](docs/images/bedrock-knowledge-base.png) |
| S3 Vectors | [Vector storage evidence](docs/images/s3-vector-storage.png) |
| RAG incident analysis | [Incident analysis](docs/images/rag-incident-analysis.png) |
| Human approval safeguards | [Approval safeguards](docs/images/human-approval-safeguards.png) |
| Prompt-injection evaluation | [Security test](docs/images/prompt-injection-security-test.png) |

These images are supporting evidence for the documented project activities. They should be interpreted alongside the implementation details, observed test results, and limitations.

## Limitations

This project is a research and demonstration prototype rather than a production incident response platform.

Its limitations include:

- Evaluation using synthetic incident data.
- A limited set of four adversarial security tests.
- Local simulation rather than live knowledge-base poisoning for PI-03 and PI-04.
- No autonomous remediation capability.
- No completed automated runtime enforcement of the runbook hash baseline.
- No claim of comprehensive prompt-injection resistance.
- Dependence on AWS services and configuration for reproducing the deployed workflow.

## Cleanup and Cost Control

After completing deployment and security evaluation, the Terraform-managed AWS infrastructure was destroyed.

The Terraform destroy operation reported:

```text
Destroy complete! Resources: 12 destroyed.
```

The Terraform state was subsequently checked and contained no remaining managed resources.

The source code and infrastructure definitions remain available for review and reproduction. Recreating the environment may incur AWS charges.

## Key Outcomes

This capstone demonstrates practical experience with:

- Cloud security incident triage
- Generative AI for security analysis
- Amazon Bedrock
- Retrieval-augmented generation
- Amazon S3 and S3 Vectors
- Terraform infrastructure as code
- AWS IAM permissions
- Prompt-injection testing
- Simulated knowledge-base poisoning
- Source-trust and authority-confusion analysis
- Human-in-the-loop security controls
- Infrastructure cleanup and cost awareness

## Project Status

**Completed research prototype.**

The AWS deployment and evaluation were completed, and the cloud infrastructure was subsequently decommissioned.

The repository preserves the implementation, synthetic test data, infrastructure definitions, security test artifacts, and project documentation.

