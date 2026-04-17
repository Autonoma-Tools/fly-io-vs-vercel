#!/usr/bin/env bash
#
# fly-preview.sh — create and destroy Fly.io preview environments for PRs.
#
# Usage:
#   bash scripts/fly-preview.sh deploy  <PR_NUMBER> <BASE_APP_NAME>
#   bash scripts/fly-preview.sh destroy <PR_NUMBER> <BASE_APP_NAME>
#
# Requirements:
#   - flyctl installed and on PATH (https://fly.io/docs/hands-on/install-flyctl/)
#   - FLY_API_TOKEN exported in the environment (set as a GitHub Actions secret)
#   - fly.pr.toml present at the repo root (overrides machine specs for previews)
#
# Derived app name: pr-<PR_NUMBER>-<BASE_APP_NAME>
# Preview URL:      https://pr-<PR_NUMBER>-<BASE_APP_NAME>.fly.dev

set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 <deploy|destroy> <PR_NUMBER> <BASE_APP_NAME>

Examples:
  $0 deploy  42 myapp    # creates pr-42-myapp.fly.dev
  $0 destroy 42 myapp    # tears down pr-42-myapp
EOF
  exit 1
}

if [[ $# -ne 3 ]]; then
  usage
fi

ACTION="$1"
PR_NUMBER="$2"
BASE_APP_NAME="$3"

if ! [[ "$PR_NUMBER" =~ ^[0-9]+$ ]]; then
  echo "error: PR_NUMBER must be a positive integer, got '$PR_NUMBER'" >&2
  exit 1
fi

if [[ -z "${FLY_API_TOKEN:-}" ]]; then
  echo "error: FLY_API_TOKEN is not set. Export it or configure it as a GitHub Actions secret." >&2
  exit 1
fi

if ! command -v flyctl >/dev/null 2>&1; then
  echo "error: flyctl is not installed. See https://fly.io/docs/hands-on/install-flyctl/" >&2
  exit 1
fi

APP_NAME="pr-${PR_NUMBER}-${BASE_APP_NAME}"
PREVIEW_URL="https://${APP_NAME}.fly.dev"

app_exists() {
  flyctl status --app "$APP_NAME" >/dev/null 2>&1
}

deploy() {
  if ! app_exists; then
    echo "Creating Fly app: $APP_NAME"
    flyctl apps create "$APP_NAME" --generate-name=false
  else
    echo "Fly app $APP_NAME already exists — redeploying."
  fi

  if [[ ! -f fly.pr.toml ]]; then
    echo "error: fly.pr.toml not found at repo root." >&2
    exit 1
  fi

  echo "Deploying $APP_NAME with fly.pr.toml"
  flyctl deploy \
    --app "$APP_NAME" \
    --config fly.pr.toml \
    --remote-only \
    --yes

  echo "Preview URL: $PREVIEW_URL"

  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    {
      echo "preview_url=$PREVIEW_URL"
      echo "app_name=$APP_NAME"
    } >> "$GITHUB_OUTPUT"
  fi
}

destroy() {
  if ! app_exists; then
    echo "Fly app $APP_NAME does not exist — nothing to destroy."
    return 0
  fi

  echo "Destroying Fly app: $APP_NAME"
  flyctl apps destroy "$APP_NAME" --yes
}

case "$ACTION" in
  deploy)  deploy  ;;
  destroy) destroy ;;
  *)       usage   ;;
esac
