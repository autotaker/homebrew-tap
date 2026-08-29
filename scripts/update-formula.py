#!/usr/bin/env python3
"""Render the four-platform backlog Homebrew formula from release checksums."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

ASSETS = {
    "darwin_arm64",
    "darwin_amd64",
    "linux_arm64",
    "linux_amd64",
}
CHECKSUM_LINE = re.compile(r"^([0-9a-f]{64})  (backlog_([^ ]+))$")
VERSION = re.compile(r"^[0-9]+\.[0-9]+\.[0-9]+$")


def read_checksums(path: Path, version: str) -> dict[str, str]:
    checksums: dict[str, str] = {}
    prefix = f"backlog_{version}_"
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        match = CHECKSUM_LINE.fullmatch(raw_line)
        if match is None:
            continue
        digest, filename, _ = match.groups()
        if not filename.startswith(prefix) or not filename.endswith(".tar.gz"):
            continue
        asset = filename.removeprefix(prefix).removesuffix(".tar.gz")
        if asset in ASSETS:
            checksums[asset] = digest
    missing = sorted(ASSETS - checksums.keys())
    if missing:
        raise SystemExit(f"missing checksums: {', '.join(missing)}")
    return checksums


def render(version: str, checksums: dict[str, str]) -> str:
    base = "https://github.com/autotaker/agent-harness-backlog/releases/download"

    def stanza(platform: str, arch: str) -> str:
        key = f"{platform}_{arch}"
        filename = f"backlog_{version}_{platform}_{arch}.tar.gz"
        return "\n".join(
            [
                f'      url "{base}/v{version}/{filename}"',
                f'      sha256 "{checksums[key]}"',
            ]
        )

    return f'''class Backlog < Formula
  desc "Local backlog management CLI for agent execution plans"
  homepage "https://github.com/autotaker/agent-harness-backlog"
  license "Apache-2.0"

  on_macos do
    on_arm do
{stanza("darwin", "arm64")}
    end
    on_intel do
{stanza("darwin", "amd64")}
    end
  end

  on_linux do
    on_arm do
{stanza("linux", "arm64")}
    end
    on_intel do
{stanza("linux", "amd64")}
    end
  end

  def install
    bin.install "backlog"
    prefix.install "LICENSE", "THIRD_PARTY_NOTICES"
  end

  test do
    output = shell_output("#{{bin}}/backlog version --json")
    assert_match version.to_s, output
    assert_match "build_time", output
  end
end
'''


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--version", required=True)
    parser.add_argument("--checksums", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if VERSION.fullmatch(args.version) is None:
        raise SystemExit("version must match major.minor.patch")
    args.output.write_text(
        render(args.version, read_checksums(args.checksums, args.version)),
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
