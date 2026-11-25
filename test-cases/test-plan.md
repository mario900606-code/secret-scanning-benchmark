# Secret Scanning Benchmark - Test Plan

## Objective

Evaluate Kingfisher and TruffleHog as potential
secret scanning solutions for DevSecOps environments.

## Test Environment

- Docker Desktop
- Windows / Git Bash
- Kingfisher 2.20.0
- TruffleHog 3.100.1
- Synthetic Git repositories
- Offline scanning
- Read-only repository access
- External verification disabled

## Functional Test Cases

| ID | Test scenario | Acceptance criteria |
|---|---|---|
| TC-01 | Initial credential detection | Relevant synthetic credentials are detected |
| TC-02 | Private key detection | Synthetic private key is identified |
| TC-03 | Historical credential detection | Removed credential is detected in Git history |
| TC-04 | Current source scanning | Removed historical credential is not reported |
| TC-05 | Clean repository | No false findings in the clean dataset |
| TC-06 | Extended credential detection | Detection results recorded by credential category |
| TC-07 | Clean build | Security gate permits execution |
| TC-08 | Exposed credential build | Security gate blocks execution |
| TC-09 | Historical credential build | Full-history security gate blocks execution |
| TC-10 | Invalid repository input | Wrapper rejects invalid repository |
| TC-11 | Invalid scanner target | Scanner returns a non-zero exit code |
| TC-12 | Centralized scanning | All four repositories receive a scan result |
| TC-13 | Incomplete coverage | Missing Git metadata is reported as an error |
| TC-14 | Missing build control | Simulated inventory identifies missing scanning |
| TC-15 | Automated scan wrapper | Both scanners execute sequentially |
| TC-16 | Safe pipeline output | Wrapper does not print credential values |
| TC-17 | Native redaction | Availability and behavior are documented |
| TC-18 | Performance | Internal and end-to-end durations are recorded |

## Extended Detection Dataset

| ID | Credential category |
|---|---|
| EXT-01 | AWS credentials |
| EXT-02 | GitHub Personal Access Token |
| EXT-03 | Stripe API key |
| EXT-04 | Slack bot token |
| EXT-05 | GitLab Personal Access Token |
| EXT-06 | SendGrid API key |
| EXT-07 | Generic password |
| EXT-08 | PostgreSQL connection URI |
| EXT-09 | MongoDB connection URI |
| EXT-10 | RSA private key |

## Evaluation Criteria

- Detection coverage in the synthetic dataset.
- Git history scanning.
- False findings in negative controls.
- Build integration.
- Centralized scanning.
- Error handling.
- Reporting quality.
- Sensitive output handling.
- Execution overhead.
- Licensing and operational considerations.

## Out of Scope

- Production repositories.
- Active credentials.
- Live credential verification.
- Credential revocation.
- Blast radius investigation.
- Large-scale performance testing.
- Real GitHub organization integration.
- Actual timed scheduler execution.

