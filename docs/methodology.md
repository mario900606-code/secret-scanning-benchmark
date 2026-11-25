# Test Methodology

## Objective

Evaluate the practical suitability of Kingfisher
and TruffleHog for automated secret scanning
in DevSecOps environments.

## Evaluation Approach

Both scanners were evaluated using the same
local synthetic Git repositories.

The evaluation included:

1. Initial credential detection.
2. Historical credential detection.
3. Negative control testing.
4. Extended credential detection.
5. Simulated CI/CD build blocking.
6. Centralized repository scanning.
7. Invalid target handling.
8. Incomplete repository coverage.
9. Security control coverage simulation.
10. Automated sequential execution.
11. End-to-end performance measurements.

## Controlled Conditions

| Parameter | Configuration |
|---|---|
| Operating environment | Windows / Git Bash |
| Container runtime | Docker Desktop |
| Kingfisher version | 2.20.0 |
| TruffleHog version | 3.100.1 |
| Network access | Disabled |
| Credential verification | Disabled |
| Repository access | Read-only |
| Test repositories | Identical for both scanners |

## Detection Measurement

Each synthetic credential category was evaluated
based on whether the intended test file and
credential type produced a relevant finding.

The extended dataset contained ten credential
categories.

Multiple findings for the same category were
not counted as additional successful detections.

## Negative Controls

A clean repository containing environment
variable references and non-sensitive
configuration was scanned by both tools.

The current source file in the historical
repository was also tested separately.

## Performance Measurement

Two types of execution time were recorded:

- Scanner-reported internal scan duration.
- End-to-end Docker execution time.

These measurements represent different scopes
and must not be directly treated as equivalent.

End-to-end timing includes container startup,
scanner initialization and scanning overhead.

## Error Handling

Both scanners were tested against nonexistent
repository paths.

Central scan error handling was additionally
tested using a directory without Git metadata.

## Limitations

The dataset is intentionally small and synthetic.

Credential formats may differ from real
provider-issued credentials.

Detection results are not representative of
general production detection accuracy.

Randomly regenerated test credentials may
produce different detector results.

No live credential verification, revocation,
production integration or large-scale
performance testing was performed.
