#!/usr/bin/env bash
# Restore test: a backup is only real once it has been restored and compared.
#
#   examples/backup/restore-test.sh [SOURCE_DIR]
#
# 1. archives SOURCE_DIR (default: a generated sample) into a backup directory,
# 2. restores the archive into a fresh temporary directory,
# 3. compares file checksums of the original and the restored copy,
# 4. exits 0 only if every file matches. Run it after every backup job.
set -euo pipefail

SRC="${1:-}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if [[ -z "$SRC" ]]; then
  SRC="$WORK/sample"
  mkdir -p "$SRC/config" "$SRC/data"
  printf 'service=example\nport=8080\n' > "$SRC/config/app.conf"
  seq 1 500 > "$SRC/data/numbers.txt"
  printf 'quarterly figures\n' > "$SRC/data/report with spaces.txt"
fi
[[ -d "$SRC" ]] || { echo "FAIL: source directory not found: $SRC" >&2; exit 2; }

BACKUP_DIR="$WORK/backup"
RESTORE_DIR="$WORK/restore"
mkdir -p "$BACKUP_DIR" "$RESTORE_DIR"

ARCHIVE="$BACKUP_DIR/backup-$(date -u +%Y%m%dT%H%M%SZ).tar.gz"
tar -C "$SRC" -czf "$ARCHIVE" .
tar -C "$RESTORE_DIR" -xzf "$ARCHIVE"

checksums() { (cd "$1" && find . -type f -print0 | sort -z | xargs -0 sha256sum); }
if diff <(checksums "$SRC") <(checksums "$RESTORE_DIR") >/dev/null; then
  files="$(find "$RESTORE_DIR" -type f | wc -l | tr -d ' ')"
  echo "OK: restored $files files, checksums match ($(basename "$ARCHIVE"))"
else
  echo "FAIL: restored files differ from the source" >&2
  exit 1
fi
