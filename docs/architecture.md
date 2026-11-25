# System Architecture

## Overview

The Secret Scanning Benchmark uses an isolated
container-based architecture to evaluate two
open-source secret scanning tools under comparable
conditions.

## High-Level Architecture

```mermaid
flowchart TB
    subgraph Test_Environment["Synthetic Test Environment"]
        A[Clean Repository]
        B[Exposed Repository]
        C[Historical Repository]
        D[Extended Repository]
    end

    subgraph Docker["Isolated Docker Environment"]
        K[Kingfisher 2.20.0]
        T[TruffleHog 3.100.1]
    end

    subgraph Automation["Automation Layer"]
        E[Build Security Gate]
        F[Central Scan Script]
        G[Coverage Check]
        H[Scheduled Scan Wrapper]
    end

    subgraph Reporting["Reporting Layer"]
        I[Sanitized CSV Reports]
        J[Benchmark Results]
        L[Security Assessment]
    end

    Test_Environment --> K
    Test_Environment --> T
    K --> Automation
    T --> Automation
    Automation --> Reporting
```

## Security Boundaries

- Repository mounts are read-only.
- Scanner containers have no network access.
- External credential validation is disabled.
- Generated credentials are synthetic.
- Raw scanner reports remain local.
- Public reports contain sanitized results only.

## CI/CD Security Gate

```mermaid
flowchart TD
    A[Build request] --> B[Secret scanning]
    B --> C{Scanner exit code}
    C -->|Zero| D[Permit simulated build]
    C -->|Findings| E[Block build]
    C -->|Error| F[Block build]
    E --> G[Remediation]
    F --> H[Investigate scan failure]
```

The security gate normalizes scanner-specific
exit codes into a common pipeline result.

## Centralized Scanning

```mermaid
flowchart LR
    A[Manual trigger or scheduler] --> B[Repository discovery]
    B --> C[Scan repositories]
    C --> D{Processing status}
    D --> E[CLEAN]
    D --> F[FINDINGS]
    D --> G[ERROR]
    E --> H[Central CSV report]
    F --> H
    G --> H
    H --> I[Coverage assessment]
```

## Coverage Model

The central scanning script reports the number
of discovered and successfully processed local
repository directories.

A separate simulated inventory represents
build-time security control coverage.

These are independent measurements and do not
establish complete content-level scan coverage.

## Production Considerations

A production implementation should include:

- Authoritative repository inventory.
- Least-privilege scanner identities.
- Centrally maintained pipeline templates.
- Required security status checks.
- Restricted reporting and alerting.
- Secret rotation and incident response.
- Scan completeness verification.
- Automated scheduling and monitoring.
