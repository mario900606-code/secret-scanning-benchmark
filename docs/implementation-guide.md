# Implementation Guide

## Recommended Rollout Strategy

### Phase 1 - Repository Inventory

Establish an authoritative inventory of all
repositories included in the security scope.

Identify repository owners, criticality and
existing CI/CD security controls.

### Phase 2 - Initial Historical Assessment

Perform an initial full Git history scan.

Review findings and assign remediation
responsibilities.

Rotate or revoke exposed credentials before
considering history cleanup.

### Phase 3 - Pilot Implementation

Select a small set of representative repositories.

Evaluate Kingfisher as the initial pilot
candidate while retaining TruffleHog as an
alternative and complementary benchmark.

Validate relevant credential formats,
reporting requirements and operational impact.

### Phase 4 - Build Integration

Integrate scanning into centrally maintained
CI/CD templates where possible.

Initially operate in reporting mode to
identify unexpected false positives.

After tuning, enforce build blocking for
findings that meet the organization's policy.

Prefer scanning newly introduced changes
after the historical baseline assessment.

Configure required status checks where
supported by the repository platform.

### Phase 5 - Centralized Scanning

Establish an independently managed scanner
with authorized read-only repository access.

Compare discovered and scanned repositories
against the authoritative inventory.

Report findings, failed scans and missing
security controls separately.

### Phase 6 - Quarterly Assessment

Run an independent centralized assessment
at least quarterly.

An example GitHub Actions schedule is:

    0 6 1 1,4,7,10 *

This represents 06:00 UTC on the first day
of January, April, July and October.

The actual scheduled trigger has not been
validated in this laboratory.

### Phase 7 - Continuous Improvement

Monitor:

- Repository scanning coverage.
- Failed and incomplete scans.
- Newly introduced secrets.
- Credential remediation time.
- Repeated security findings.
- Build security control adoption.
- Scanner execution overhead.

## Suggested Responsibilities

| Activity | Suggested owner |
|---|---|
| Security requirements | Information Security |
| Scanner platform | DevSecOps / Platform Engineering |
| CI/CD integration | Development / Platform teams |
| Credential rotation | System or credential owner |
| Quarterly assessment | Information Security |
| Exception approval | Authorized security owner |

## Cost Considerations

Open-source licensing does not eliminate
operational costs.

Consider infrastructure, CI/CD execution,
maintenance, reporting, alert handling and
credential remediation.

Actual costs depend on repository volume,
build frequency, infrastructure and staffing.

## Production Approval Criteria

- Relevant credential types are detectable.
- Sensitive scanner output is protected.
- Scanner versions are controlled.
- Failed and incomplete scans are identified.
- Repository inventory is authoritative.
- Required security checks cannot be
  bypassed without approved exceptions.
- Remediation ownership is established.
