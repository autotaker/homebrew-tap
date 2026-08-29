class Backlog < Formula
  desc "Local backlog management CLI for agent execution plans"
  homepage "https://github.com/autotaker/agent-harness-backlog"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v0.1.1/backlog_0.1.1_darwin_arm64.tar.gz"
      sha256 "3bf748392762ed7ab2f906645ae0eb5f188684afb356312b10117f54c0bdfb43"
    end
    on_intel do
      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v0.1.1/backlog_0.1.1_darwin_amd64.tar.gz"
      sha256 "196e15ccf9c3245144d77eb1a2b0acc1d5f6909be1edc7178e3e4817275cf10d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v0.1.1/backlog_0.1.1_linux_arm64.tar.gz"
      sha256 "2478ca1748c158b3ceb54b01d98639ccc15eb37b2eca4a3ccbeebb10c410a02c"
    end
    on_intel do
      url "https://github.com/autotaker/agent-harness-backlog/releases/download/v0.1.1/backlog_0.1.1_linux_amd64.tar.gz"
      sha256 "ece6e40836dd59698fe46845e96df3c2de28033fecdcb5e176a54afabde4f0ad"
    end
  end

  def install
    bin.install "backlog"
    prefix.install "LICENSE", "THIRD_PARTY_NOTICES"
  end

  test do
    output = shell_output("#{bin}/backlog version --json")
    assert_match version.to_s, output
    assert_match "build_time", output
  end
end
