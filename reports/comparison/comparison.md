# Secret Scanning - Comparative Security Assessment

## Executive Summary

This assessment compares Kingfisher and TruffleHog
as potential open-source secret scanning solutions.

Both tools successfully demonstrated core capabilities
required for automated secret detection, historical
scanning, simulated CI/CD security gates and
centralized repository assessments.

Neither tool demonstrated complete detection across
the extended synthetic credential dataset.

Kingfisher is recommended as an initial pilot
candidate, subject to further technical and
organizational validation.

## Comparative Results

| Category | Kingfisher | TruffleHog |
|---|---|---|
| Extended detection | 6/10 | 5/10 |
| Git history | Supported and tested | Supported and tested |
| Build blocking | Tested | Tested |
| Centralized scanning | Tested | Tested |
| Error handling | Tested | Tested |
| Native redaction | Demonstrated | Not demonstrated |
| Confidence scoring | Demonstrated | Not shown |
| Rotation guidance | Not shown | Demonstrated |
| Average build scan | 11 s | 8.75 s |
| Central scan duration | 44 s | 35-37 s |

## Kingfisher

### Observed Strengths

- Broader detection in the extended dataset.
- Native redaction of secret values.
- Detailed confidence and entropy information.
- Detection fingerprints.
- Historical commit metadata.
- Machine-readable reporting options.
- Short internal scan durations.

### Observed Limitations

- Did not detect the synthetic AWS credentials.
- Did not detect every extended credential type.
- Higher end-to-end Docker execution time.
- Scan completeness requires additional validation
  before production enforcement.

## TruffleHog

### Observed Strengths

- Detected synthetic AWS credentials.
- Detailed Git commit information.
- Credential rotation guidance.
- Lower end-to-end Docker execution time.
- Explicit non-zero finding exit code.
- Machine-readable reporting options.

### Observed Limitations

- Printed raw credentials in the tested output mode.
- Did not detect certain categories identified
  by Kingfisher.
- Requires controlled handling of scanner output.

## Operational Considerations

Both scanners can be operated through containers.

Operational costs include:

- Infrastructure and CI/CD execution.
- Integration development.
- Scanner maintenance.
- Security monitoring.
- Finding triage.
- Credential remediation.
- Reporting and governance.

Open-source licensing does not eliminate these costs.

Exact licensing obligations should be reviewed
against the tested release and intended deployment.

## Recommended Security Architecture

Use a layered approach:

1. Initial full-history assessment.
2. Incremental build-time scanning.
3. Mandatory security checks.
4. Centralized independent repository scanning.
5. Quarterly security control assessments.
6. Controlled credential remediation.

## Recommendation

Kingfisher is recommended as the initial pilot
candidate because of its demonstrated native
redaction, finding metadata and broader detection
within the extended synthetic dataset.

TruffleHog remains a strong alternative due to
its AWS detection and lower observed Docker
execution overhead.

A complementary dual-scanner approach may also
be evaluated where additional detection coverage
justifies the operational cost.

## Decision Conditions

Before selecting a production solution:

- Validate representative credential formats.
- Confirm applicable licensing terms.
- Evaluate actual CI/CD overhead.
- Verify scan completeness.
- Establish authoritative repository inventory.
- Protect raw scanner results.
- Define remediation ownership.
- Establish approved exception handling.

## Conclusion

Both tools are viable candidates for further
evaluation.

The laboratory results demonstrate technical
feasibility but do not establish production
readiness or universal detection accuracy.

