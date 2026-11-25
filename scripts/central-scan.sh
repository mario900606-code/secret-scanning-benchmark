#!/usr/bin/env bash

set -u

SCANNER="${1:-}"

cd "$(dirname "$0")/.." || exit 1

case "$SCANNER" in
    kingfisher|trufflehog) ;;
    *)
        echo "Usage: bash scripts/central-scan.sh <scanner>"
        exit 1
        ;;
esac

mkdir -p "reports/$SCANNER"
mkdir -p reports/comparison

TIMESTAMP=$(date +%Y%m%d-%H%M%S)

REPORT="reports/comparison/central-$SCANNER-$TIMESTAMP.csv"

echo "repository,scanner,status,exit_code,duration_seconds" > "$REPORT"

TOTAL=0
CLEAN=0
FINDINGS=0
ERRORS=0

SCAN_START=$(date +%s)

echo "=========================================="
echo "CENTRALIZED SECRET SCANNING"
echo "=========================================="
echo "Scanner: $SCANNER"
echo "Started: $(date)"
echo ""

for REPO_PATH in repos/*; do

    [ -d "$REPO_PATH" ] || continue

    REPO=$(basename "$REPO_PATH")

    TOTAL=$((TOTAL+1))

    echo "Scanning: $REPO"

    START=$(date +%s)

    LOG="reports/$SCANNER/central-$REPO.txt"

    if [ ! -d "$REPO_PATH/.git" ]; then

        RESULT=2

    elif [ "$SCANNER" = "kingfisher" ]; then

        MSYS_NO_PATHCONV=1 docker compose run --rm kingfisher \
          scan "/repos/$REPO" \
          --git-history full \
          --no-validate \
          --no-update-check \
          --redact \
          --format pretty \
          > "$LOG" 2>&1

        RESULT=$?

    else

        MSYS_NO_PATHCONV=1 docker compose run --rm trufflehog \
          git "file:///repos/$REPO" \
          --no-verification \
          --no-update \
          --results=verified,unknown,unverified \
          --fail \
          --fail-on-scan-errors \
          > "$LOG" 2>&1

        RESULT=$?

    fi

    END=$(date +%s)

    DURATION=$((END-START))

    case "$SCANNER:$RESULT" in

        kingfisher:0|trufflehog:0)
            STATUS="CLEAN"
            CLEAN=$((CLEAN+1))
            ;;

        kingfisher:200|kingfisher:205|trufflehog:183)
            STATUS="FINDINGS"
            FINDINGS=$((FINDINGS+1))
            ;;

        *)
            STATUS="ERROR"
            ERRORS=$((ERRORS+1))
            ;;

    esac

    echo "Result: $STATUS ($DURATION seconds)"
    echo "$REPO,$SCANNER,$STATUS,$RESULT,$DURATION" >> "$REPORT"

    echo ""

done

SCAN_END=$(date +%s)

SCANNED=$((CLEAN+FINDINGS))

if [ "$TOTAL" -gt 0 ]; then
    COVERAGE=$((SCANNED*100/TOTAL))
else
    COVERAGE=0
fi

echo "=========================================="
echo "CENTRAL SCAN SUMMARY"
echo "=========================================="
echo "Scanner:               $SCANNER"
echo "Repositories found:    $TOTAL"
echo "Reported successful:   $SCANNED"
echo "Clean repositories:     $CLEAN"
echo "Repos with findings:    $FINDINGS"
echo "Failed scans:           $ERRORS"
echo "Reported coverage:      $COVERAGE%"
echo "Total execution time:  $((SCAN_END-SCAN_START)) seconds"
echo "Report:                $REPORT"
echo "=========================================="

if [ "$ERRORS" -gt 0 ] || [ "$TOTAL" -eq 0 ]; then
    exit 2
elif [ "$FINDINGS" -gt 0 ]; then
    exit 1
else
    exit 0
fi
