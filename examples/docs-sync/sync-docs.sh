#!/usr/bin/env bash
# Sanitized example: pull the canonical infrastructure docs into a read-only clone.
# Local changes in the clone are discarded by design — edit the canonical repo instead.
set -euo pipefail

CLONE_DIR="${HOME}/infra-docs"
LOG_FILE="${CLONE_DIR}/.sync.log"
export GIT_SSH_COMMAND="ssh -i ${HOME}/.ssh/docs_pull -o IdentitiesOnly=yes -o BatchMode=yes"

cd "${CLONE_DIR}"
{
  echo "=== $(date -Is)"
  git fetch --quiet origin main
  git reset --quiet --hard origin/main
  echo "ok $(git rev-parse --short HEAD)"
} >>"${LOG_FILE}" 2>&1
