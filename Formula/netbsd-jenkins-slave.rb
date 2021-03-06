require File.expand_path("../../BaseFormula/bsd-jenkins-slave.rb", __FILE__)

class NetbsdJenkinsSlave < Formula

  include BsdJenkinsSlave

  def bsd_flavor
    "NetBSD"
  end

  desc "NetBSD Jenkins Slave"
  homepage "https://github.com/riboseinc/bsd-jenkins-slaves"
  # url "https://github.com/riboseinc/rnp/archive/0.8.0.tar.gz"
  # sha256 "b61ae76934d4d125660530bf700478b8e4b1bb40e75a4d60efdb549ec864c506"
  head "https://github.com/riboseinc/bsd-jenkins-slaves.git"

  # Custom requirements
  depends_on VagrantRequirement
  depends_on VirtualboxRequirement

  devel do
    version '0.1.0'
  end

  plist_options startup: false

  test do
    # system "jenkins-freebsd-up", "--version"
  end
end
