#!/usr/bin/env bash

cd "$(dirname "$0")/.." || exit 2

echo "=================================="
echo "SCHEDULED SECRET SCANNING"
echo "=================================="
echo "Started: $(date)"

bash scripts/central-scan.sh kingfisher
KF_RESULT=$?

bash scripts/central-scan.sh trufflehog
TH_RESULT=$?

echo ""
echo "=================================="
echo "SCHEDULED SCAN SUMMARY"
echo "=================================="
echo "Kingfisher status: $KF_RESULT"
echo "TruffleHog status: $TH_RESULT"
echo "Completed: $(date)"

if [ "$KF_RESULT" -gt 1 ] || [ "$TH_RESULT" -gt 1 ]; then
    exit 2
elif [ "$KF_RESULT" -eq 1 ] || [ "$TH_RESULT" -eq 1 ]; then
    exit 1
else
    exit 0
fi
