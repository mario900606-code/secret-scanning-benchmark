#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

echo "========================================"
echo "SECRET SCANNING BENCHMARK - LAB SETUP"
echo "========================================"

for tool in git openssl ssh-keygen docker; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "[ERROR] Required tool missing: $tool"
        exit 2
    fi
done

for repo in repo-clean repo-exposed repo-history repo-extended; do
    if [ -e "repos/$repo" ]; then
        echo "[ERROR] Target already exists: repos/$repo"
        echo "Existing repositories will not be overwritten."
        exit 2
    fi
done

mkdir -p repos
mkdir -p reports/{kingfisher,trufflehog,comparison}

for repo in repo-clean repo-exposed repo-history repo-extended; do

    mkdir -p "repos/$repo"

    git init -b main "repos/$repo"

    git -C "repos/$repo" config user.name "Security Lab"

    git -C "repos/$repo" config user.email "lab@example.invalid"

    git -C "repos/$repo" config core.autocrlf false

done

echo "[1/4] Creating clean repository"

cat > repos/repo-clean/app.py <<'PY'
import os

DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD")
API_KEY = os.getenv("API_KEY")
DATABASE_HOST = "localhost"
DATABASE_PORT = 5432

def connect():
    print("Application configuration loaded")

if __name__ == "__main__":
    connect()
PY

cat > repos/repo-clean/config.json <<'JSON'
{
  "application": "Demo Application",
  "environment": "development",
  "debug": false,
  "api_url": "https://api.example.invalid",
  "timeout": 30
}
JSON

git -C repos/repo-clean add .
git -C repos/repo-clean commit -m "Add secure configuration"

echo "[2/4] Creating exposed repository"

cat > repos/repo-exposed/config.py <<'PY'
# Synthetic credentials for offline security testing only

DATABASE_PASSWORD = "DemoPassword2026!"

AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"

AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

MONGODB_URI = "mongodb://demo_user:DemoPassword2026@localhost:27017/demo"
PY

ssh-keygen -q -t ed25519 \
    -f repos/repo-exposed/synthetic_ssh \
    -N "" \
    -C "offline-security-lab"

git -C repos/repo-exposed add .
git -C repos/repo-exposed commit -m "Add synthetic exposed credentials"

echo "[3/4] Creating historical repository"

cp repos/repo-exposed/config.py repos/repo-history/config.py

git -C repos/repo-history add .
git -C repos/repo-history commit -m "Add synthetic credentials"

cat > repos/repo-history/config.py <<'PY'
import os

DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD")
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
PY

git -C repos/repo-history add .
git -C repos/repo-history commit -m "Remove hardcoded credentials"

echo "[4/4] Creating extended repository"

AWS_ID="AKIA$(openssl rand -hex 8 | tr '[:lower:]' '[:upper:]')"
AWS_SECRET="$(openssl rand -base64 30)"
GITHUB_TOKEN="ghp_$(openssl rand -hex 18)"
STRIPE_KEY="sk_test_$(openssl rand -hex 16)"
SLACK_TOKEN="xoxb-$(openssl rand -hex 6)-$(openssl rand -hex 6)-$(openssl rand -hex 12)"
GITLAB_TOKEN="glpat-$(openssl rand -hex 10)"
SENDGRID_KEY="SG.$(openssl rand -hex 11).$(openssl rand -hex 32)"
PASSWORD="$(openssl rand -hex 16)"

printf 'AWS_ACCESS_KEY_ID = "%s"\nAWS_SECRET_ACCESS_KEY = "%s"\n' \
    "$AWS_ID" "$AWS_SECRET" > repos/repo-extended/aws.py

printf 'GITHUB_TOKEN = "%s"\n' "$GITHUB_TOKEN" > repos/repo-extended/github.py

printf 'STRIPE_API_KEY = "%s"\n' "$STRIPE_KEY" > repos/repo-extended/stripe.py

printf 'SLACK_BOT_TOKEN = "%s"\n' "$SLACK_TOKEN" > repos/repo-extended/slack.py

printf 'GITLAB_TOKEN = "%s"\n' "$GITLAB_TOKEN" > repos/repo-extended/gitlab.py

printf 'SENDGRID_API_KEY = "%s"\n' "$SENDGRID_KEY" > repos/repo-extended/sendgrid.py

printf 'DATABASE_PASSWORD = "%s"\n' "$PASSWORD" > repos/repo-extended/database.py

printf 'DATABASE_URL = "postgresql://lab_user:%s@localhost:5432/lab"\n' \
    "$PASSWORD" > repos/repo-extended/postgresql.py

printf 'MONGODB_URI = "mongodb://lab_user:%s@localhost:27017/lab"\n' \
    "$PASSWORD" > repos/repo-extended/mongodb.py

ssh-keygen -q -t rsa -b 2048 \
    -f repos/repo-extended/synthetic_rsa \
    -N "" \
    -C "offline-security-lab"

git -C repos/repo-extended add .
git -C repos/repo-extended commit -m "Add extended synthetic dataset"

echo ""
echo "[SUCCESS] Lab environment created"
echo "All credentials are synthetic and must never be used for authentication."
echo "Do not publish generated repositories or raw scanner reports."
