#!/usr/bin/env bash
set -euo pipefail

binary="${1:?binary path is required}"
work_dir="$(mktemp -d)"
port="${BACKLOG_SMOKE_PORT:-4783}"
server_pid=""

cleanup() {
  if test -n "$server_pid"; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  rm -rf "$work_dir"
}
trap cleanup EXIT

version_json="$($binary version --json)"
printf '%s\n' "$version_json" | grep -F '"version"' >/dev/null
printf '%s\n' "$version_json" | grep -F '"commit"' >/dev/null
printf '%s\n' "$version_json" | grep -F '"build_time"' >/dev/null

(
  cd "$work_dir"
  "$binary" init
  test -f .backlog/backlog.db
  "$binary" serve --addr "127.0.0.1:$port"
) &
server_pid=$!

for _ in $(seq 1 30); do
  if curl --fail --silent --show-error "http://127.0.0.1:$port/" >/dev/null; then
    exit 0
  fi
  sleep 1
done

echo "backlog serve did not become ready" >&2
exit 1
