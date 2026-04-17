#!/usr/bin/env bash
#
# examples/deploy-pr-42.sh — end-to-end example of using the preview script locally.
#
# Prereqs:
#   - flyctl installed: https://fly.io/docs/hands-on/install-flyctl/
#   - FLY_API_TOKEN exported (get one via `flyctl tokens create deploy`)
#
# This example simulates what the GitHub Actions workflow does for PR #42.

set -euo pipefail

export FLY_API_TOKEN="${FLY_API_TOKEN:?set FLY_API_TOKEN before running this example}"

PR_NUMBER=42
BASE_APP_NAME=myapp
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Deploying preview for PR #$PR_NUMBER"
bash "$SCRIPT_DIR/scripts/fly-preview.sh" deploy "$PR_NUMBER" "$BASE_APP_NAME"

echo
echo "==> Preview is live at https://pr-${PR_NUMBER}-${BASE_APP_NAME}.fly.dev"
echo "==> Run E2E tests, then destroy with:"
echo "    bash scripts/fly-preview.sh destroy $PR_NUMBER $BASE_APP_NAME"
