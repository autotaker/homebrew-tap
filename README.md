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

After a successful public GitHub Release, the person who created the release
tag starts the formula update from the Tap Actions UI:

1. Open `autotaker/homebrew-tap` and select **Actions** > **Update Formula**.
2. Select **Run workflow**, choose the default `main` branch, enter the exact
   published tag in the required `tag` field (for example, `v0.1.1`), and run it.
3. Inspect the resulting pull request. If GitHub pauses its checks because the
   pull request was created with `GITHUB_TOKEN`, approve the workflow checks
   when GitHub asks.
4. Merge only after the required checks and human review pass, using branch
   protection.

The workflow validates the public release archives and checksums before it
opens the pull request. Pull requests must pass the macOS/Linux matrix before
they can be merged.
