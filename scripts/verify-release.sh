#!/usr/bin/env bash
set -euo pipefail

version="${BACKLOG_VERSION:-$(sed -n 's#^      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v\([^/]*\)/.*$#\1#p' Formula/backlog.rb | head -n 1)}"
test -n "$version"
release_url="https://github.com/autotaker/agent-harness-backlog/releases/download/v${version}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

curl --fail --silent --show-error --location "$release_url/checksums.txt" --output "$tmp_dir/checksums.txt"

expected_assets=(
  "backlog_${version}_darwin_amd64.tar.gz"
  "backlog_${version}_darwin_arm64.tar.gz"
  "backlog_${version}_linux_amd64.tar.gz"
  "backlog_${version}_linux_arm64.tar.gz"
)

for asset in "${expected_assets[@]}"; do
  grep -F "  ${asset}" "$tmp_dir/checksums.txt" >/dev/null
  curl --fail --silent --show-error --location "$release_url/$asset" --output "$tmp_dir/$asset"
  expected="$(awk -v name="$asset" '$2 == name { print $1 }' "$tmp_dir/checksums.txt")"
  if command -v shasum >/dev/null 2>&1; then
    actual="$(shasum -a 256 "$tmp_dir/$asset" | awk '{ print $1 }')"
  else
    actual="$(sha256sum "$tmp_dir/$asset" | awk '{ print $1 }')"
  fi
  test "$expected" = "$actual"
done

grep -F "  backlog_${version}_windows_amd64.zip" "$tmp_dir/checksums.txt" >/dev/null
