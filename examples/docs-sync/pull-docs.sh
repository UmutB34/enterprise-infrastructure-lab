#!/usr/bin/env bash
# Read-only documentation copy: pulls the one writable repository on a schedule.
# Run from cron on each workload, for example every 15 minutes:
#   */15 * * * * /usr/local/bin/pull-docs.sh >> "$HOME/docs/.sync.log" 2>&1
#
# The key used for the pull is restricted on the server (see
# ../access/authorized_keys.forced-command.example): it can only read this one
# repository. It cannot open a shell, push, or reach any other repository.
set -euo pipefail

DOCS_DIR="${DOCS_DIR:-$HOME/docs}"
REMOTE="${DOCS_REMOTE:-ssh://docs@source.example.internal/srv/docs.git}"
export GIT_SSH_COMMAND="ssh -i ${PULL_KEY:-$HOME/.ssh/docs_pull} -o IdentitiesOnly=yes -o BatchMode=yes"

if [[ ! -d "$DOCS_DIR/.git" ]]; then
  git clone --quiet "$REMOTE" "$DOCS_DIR"
fi
cd "$DOCS_DIR"
git fetch --quiet origin
# The copy is read-only by design: throw away any local change instead of merging it.
git reset --quiet --hard origin/HEAD
echo "$(date -u +%FT%TZ) synced $(git rev-parse --short HEAD)"
