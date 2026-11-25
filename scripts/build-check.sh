#!/usr/bin/env bash

set -u

SCANNER="${1:-}"
REPO="${2:-}"

cd "$(dirname "$0")/.." || exit 1

case "$SCANNER" in
    kingfisher|trufflehog) ;;
    *)
        echo "Usage: bash scripts/build-check.sh <scanner> <repository>"
        exit 1
        ;;
esac

case "$REPO" in
    repo-clean|repo-exposed|repo-history|repo-extended) ;;
    *)
        echo "ERROR: Unknown repository"
        exit 1
        ;;
esac

if [ ! -d "repos/$REPO/.git" ]; then
    echo "ERROR: Git repository not found"
    exit 1
fi

mkdir -p "reports/$SCANNER"

LOG="reports/$SCANNER/build-$REPO.txt"

echo "=================================="
echo "CI/CD SECURITY GATE"
echo "=================================="
echo "Scanner: $SCANNER"
echo "Repository: $REPO"
echo "Starting secret scan..."
echo ""

START=$(date +%s)

if [ "$SCANNER" = "kingfisher" ]; then

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

echo "Scanner exit code: $RESULT"
echo "Execution time: $((END-START)) seconds"
echo ""

case "$SCANNER:$RESULT" in

    kingfisher:0|trufflehog:0)
        echo "[PASS] No reported secrets"
        echo "[PASS] Security gate passed"
        echo "[PASS] Simulated build completed"
        exit 0
        ;;

    kingfisher:200|kingfisher:205|trufflehog:183)
        echo "[FAIL] Potential secrets detected"
        echo "[BLOCKED] Build terminated"
        exit 1
        ;;

    *)
        echo "[ERROR] Scanner execution failed"
        echo "[BLOCKED] Build terminated"
        exit 2
        ;;

esac
