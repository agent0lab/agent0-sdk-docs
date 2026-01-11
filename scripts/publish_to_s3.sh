#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SITE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

ENV_FILE="${SITE_ROOT}/s3-publish.env"
TOKEN_FILE="${SITE_ROOT}/.aws_web_identity_token"

DEFAULT_BUCKET="sdk.ag0.xyz"

if [[ -f "${ENV_FILE}" ]]; then
  # shellcheck disable=SC1090
  set -a
  source "${ENV_FILE}"
  set +a
fi

unset_if_empty() {
  local var_name="$1"
  # If variable is set to empty string, unset it so AWS CLI doesn't misbehave.
  # Using ${!var_name-} avoids set -u errors when unset.
  if [[ "${!var_name-}" == "" ]]; then
    unset "${var_name}" || true
  fi
}

# Avoid AWS CLI producing endpoints like https://s3..amazonaws.com due to empty region/profile vars.
unset_if_empty AWS_REGION
unset_if_empty AWS_DEFAULT_REGION
unset_if_empty AWS_PROFILE

BUCKET_NAME="${S3_BUCKET:-$DEFAULT_BUCKET}"
BUCKET_URI="s3://${BUCKET_NAME}"

# If a JWT is provided, write it to a local token file and configure AWS CLI web-identity env vars.
# This supports "AssumeRoleWithWebIdentity" flows.
if [[ -n "${AWS_WEB_IDENTITY_JWT:-}" ]]; then
  if [[ -z "${AWS_ROLE_ARN:-}" ]]; then
    echo "ERROR: AWS_WEB_IDENTITY_JWT is set but AWS_ROLE_ARN is not. Set AWS_ROLE_ARN in ${ENV_FILE}."
    exit 1
  fi
  printf '%s' "${AWS_WEB_IDENTITY_JWT}" > "${TOKEN_FILE}"
  export AWS_WEB_IDENTITY_TOKEN_FILE="${TOKEN_FILE}"
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: aws CLI not found. Install it first, then rerun."
  echo "macOS (brew): brew install awscli"
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "ERROR: npm not found on PATH."
  echo "If you use nvm, you may need to run:"
  echo "  export PATH=\"\$HOME/.nvm/versions/node/<your-node-version>/bin:\$PATH\""
  exit 1
fi

cd "${SITE_ROOT}"

echo "Building site (Astro) ..."
npm run build

if [[ ! -d "${SITE_ROOT}/dist" ]]; then
  echo "ERROR: dist/ not found after build. Expected ${SITE_ROOT}/dist"
  exit 1
fi

SYNC_DELETE="${S3_SYNC_DELETE:-1}"
DRYRUN="${S3_SYNC_DRYRUN:-}"

COMMON_ARGS=(--only-show-errors)
if [[ "${DRYRUN}" == "1" ]]; then
  COMMON_ARGS+=(--dryrun)
fi

if [[ "${SYNC_DELETE}" == "1" ]]; then
  COMMON_ARGS+=(--delete)
fi

echo "Publishing dist/ -> ${BUCKET_URI} (delete=${SYNC_DELETE}, dryrun=${DRYRUN:-0})"

# Sync HTML (and other top-level content) with a short cache time.
aws s3 sync "${SITE_ROOT}/dist" "${BUCKET_URI}" \
  --exclude "_astro/*" \
  --cache-control "max-age=0, must-revalidate" \
  "${COMMON_ARGS[@]}"

# Sync hashed build assets with long-lived caching.
if [[ -d "${SITE_ROOT}/dist/_astro" ]]; then
  aws s3 sync "${SITE_ROOT}/dist/_astro" "${BUCKET_URI}/_astro" \
    --cache-control "max-age=31536000, immutable" \
    "${COMMON_ARGS[@]}"
fi

echo "Done. If S3 static hosting is configured, your site should be live from the ${BUCKET_NAME} endpoint."

