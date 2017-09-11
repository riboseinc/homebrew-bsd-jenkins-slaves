require 'requirement'

class VagrantRequirement < Requirement
  fatal true
  cask "vagrant"
  download "https://www.vagrantup.com"

  satisfy { which("vagrant") }

  def message
    s = <<-EOS.undent
      Vagrant must be installed for Homebrew to install this formula.
      Make sure that "vagrant" is in your PATH before proceeding.
    EOS
    s += super
    s
  end
end