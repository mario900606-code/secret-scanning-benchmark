# Secret Scanning Benchmark – Test Results

## Test Information

| Parameter | Value |
|---|---|
| Execution date | 2026-11-25 |
| Kingfisher version | 2.20.0 |
| TruffleHog version | 3.100.1 |
| Environment | Docker Desktop / Windows / Git Bash |
| Credential validation | Disabled |
| Container network access | Disabled |
| Repository access | Read-only |

## Functional Test Results

| ID | Test scenario | Kingfisher | TruffleHog |
|---|---|---|---|
| TC-01 | Initial secret detection | 2 findings | 2 findings |
| TC-02 | Private key detection | PASS | PASS |
| TC-03 | Historical secret detection | PASS | PASS |
| TC-04 | Current source negative control | PASS | PASS |
| TC-05 | Clean repository | PASS | PASS |
| TC-06 | Extended detection | 6/10 | 5/10 |
| TC-07 | Clean build permitted | PASS | PASS |
| TC-08 | Exposed credential build blocked | PASS | PASS |
| TC-09 | Historical credential build blocked | PASS | PASS |
| TC-10 | Invalid repository input | PASS | PASS |
| TC-11 | Invalid scanner target | PASS | PASS |
| TC-12 | Centralized scanning | PASS | PASS |
| TC-13 | Incomplete repository coverage | PASS | PASS |
| TC-14 | Missing build control simulation | PASS | PASS |
| TC-15 | Automated scan wrapper | PASS | PASS |
| TC-16 | Safe wrapper console output | PASS | PASS |
| TC-17 | Native redaction | Demonstrated | Not demonstrated |
| TC-18 | Performance measurement | Completed | Completed |

## Extended Detection Results

| Credential type | Kingfisher | TruffleHog |
|---|---|---|
| AWS credentials | Not detected | Detected |
| GitHub PAT | Detected | Detected |
| Stripe API key | Not detected | Not detected |
| Slack bot token | Not detected | Not detected |
| GitLab PAT | Detected | Detected |
| SendGrid API key | Detected | Not detected |
| Generic password | Not detected | Not detected |
| PostgreSQL URI | Detected | Not detected |
| MongoDB URI | Detected | Detected |
| RSA private key | Detected | Detected |
| Total | 6/10 | 5/10 |

Combined detection: 7 of 10 synthetic categories.

These results do not represent general detection accuracy.

## Scanner Exit Codes

| Scenario | Kingfisher | TruffleHog |
|---|---|---|
| No findings | 0 | 0 |
| Findings detected | 200 | 183 |
| Invalid scan target | 1 | 1 |

## Centralized Scanning

| Metric | Kingfisher | TruffleHog |
|---|---|---|
| Repositories discovered | 4 | 4 |
| Repositories processed | 4 | 4 |
| Clean repositories | 1 | 1 |
| Repositories with findings | 3 | 3 |
| Failed scans | 0 | 0 |
| Reported coverage | 100% | 100% |

## Incomplete Coverage Test

| Metric | Kingfisher | TruffleHog |
|---|---|---|
| Discovered directories | 5 | 5 |
| Successfully processed | 4 | 4 |
| Failed entries | 1 | 1 |
| Reported coverage | 80% | 80% |
| Wrapper exit code | 2 | 2 |

## Security Control Coverage

- Simulated build scanning coverage: 75%.
- Central repository processing coverage: 100%.
- Missing build control identified successfully.

## Performance Results

### Internal scanner duration

| Repository | Kingfisher | TruffleHog |
|---|---|---|
| Exposed | 0.373 s | 5.534 s |
| Historical | 0.677 s | 5.389 s |
| Clean | 0.560 s | 5.270 s |
| Extended | 0.642 s | 5.400 s |

### End-to-end execution

| Test round | Kingfisher | TruffleHog |
|---|---|---|
| Combined build scan steps | 44 s | 35 s |
| Central scan round 1 | 44 s | 37 s |
| Central scan round 2 | 44 s | 35 s |

Internal and end-to-end timings measure different scopes.

## Conclusion

Both scanners demonstrated the core technical
capabilities required by the laboratory assessment.

Kingfisher demonstrated broader detection in the
extended synthetic dataset and native redaction.

TruffleHog demonstrated AWS credential detection
and lower end-to-end Docker execution time.

Further representative testing is required before
making a production deployment decision.

## Limitations

- Small synthetic dataset.
- No live credential validation.
- No real GitHub organization integration.
- Simulated CI/CD and control inventory.
- Scheduled wrapper tested manually.
- No actual timed scheduler execution.
- Reported repository coverage does not establish
  complete content-level scanning coverage.
- Limited performance measurements.
