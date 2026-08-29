# Homebrew Tap for Agent Backlog

This tap distributes the `backlog` command-line tool for macOS and Linux.

## Install

```bash
brew install autotaker/tap/backlog
```

The formula supports Apple Silicon and Intel macOS, plus x86-64 and arm64
Linux. Windows users should use the Windows archive from the
[GitHub Releases](https://github.com/autotaker/agent-harness-backlog/releases).

GitHub Releases are the distribution source of truth. The formula points at
the immutable release archives and their SHA-256 values; it does not rebuild
the application or fetch Go modules during installation.

The application and the bundled notices are distributed under the Apache-2.0
license. Copyright holder: Taku Terao.

Formula updates are proposed by an automated pull request after a successful
upstream GitHub Release. Pull requests must pass the macOS/Linux matrix before
they can be merged.
