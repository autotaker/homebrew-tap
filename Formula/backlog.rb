class Backlog < Formula
  desc "Local backlog management CLI for agent execution plans"
  homepage "https://github.com/autotaker/agent-harness-backlog"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v0.1.2/backlog_0.1.2_darwin_arm64.tar.gz"
      sha256 "1b47c799e6f126eaedbfd997a3fe6656fbf5336afb065e576551ba2db57e2e87"
    end
    on_intel do
      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v0.1.2/backlog_0.1.2_darwin_amd64.tar.gz"
      sha256 "4da9e4f4aeac3fa335c0d15a9bf5f2aa6bd78698ec6ed58eca58220281fcb9d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v0.1.2/backlog_0.1.2_linux_arm64.tar.gz"
      sha256 "89b1eb9aeffade240bcce0cca2b840f470cd643f8946f6a32aa5e0063af2cbe2"
    end
    on_intel do
      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v0.1.2/backlog_0.1.2_linux_amd64.tar.gz"
      sha256 "b871af6547f17136333bde84a58abcb3a636e42b851cd98968e450509f66df0a"
    end
  end

  def install
    bin.install "backlog"
    prefix.install "LICENSE", "THIRD_PARTY_NOTICES"
  end

  test do
    output = shell_output("#{bin}/backlog version --json")
    assert_match "0.1.2", output
    assert_match "build_time", output
  end
end
