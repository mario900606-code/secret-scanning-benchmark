# Security Considerations

## Synthetic Credentials

All credentials in the test environment are
synthetic and intended exclusively for offline
security testing.

Generated private keys must never be used for
authentication.

## Scanner Output

During testing, TruffleHog displayed complete
synthetic credential values in its default
human-readable output.

Kingfisher demonstrated native redaction using
the --redact parameter.

Production scanner output must be treated as
potentially sensitive security data.

## Recommended Controls

- Restrict access to raw scanner results.
- Never publish credential values in CI logs.
- Sanitize reports before sharing.
- Use least-privilege repository access.
- Define retention periods for scan reports.
- Protect scanner configuration and identities.
- Prevent unauthorized security gate bypass.
- Review detector exceptions and allowlists.

## Credential Remediation

When a real credential is discovered:

1. Identify the responsible owner.
2. Assess potential exposure and impact.
3. Revoke or rotate the credential.
4. Investigate potential misuse.
5. Remove the credential from source code.
6. Evaluate Git history remediation.
7. Verify that the old credential is unusable.
8. Document the incident and corrective actions.

Removing a credential from the current source
file does not remove it from Git history.

## Fail-Closed Design

The laboratory build wrapper blocks execution
when findings or unexpected scanner exit codes
are encountered.

Production implementations must also validate
scan completeness and detect partial scans.

A successful exit code alone is not sufficient
evidence that all repository content was scanned.

## Public Repository Safety

Generated repositories and raw scanner reports
must remain excluded from version control.

Only sanitized benchmark results, documentation,
scripts and synthetic test generation logic
should be published.
