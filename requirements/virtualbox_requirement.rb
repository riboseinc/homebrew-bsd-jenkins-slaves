require 'requirement'

class VirtualboxRequirement < Requirement
  fatal true
  cask "virtualbox"
  download "https://www.virtualbox.org"

  satisfy { which("VBoxManage") }

  def message
    s = <<~EOS
      VirtualBox must be installed for Homebrew to install this formula.
      Make sure that "VBoxManage" is in your PATH before proceeding.
    EOS
    s += super
    s
  end
end