require File.expand_path("../requirements/vagrant.rb", __FILE__)

class FreebsdJenkinsSlave < Formula
  desc "FreeBSD Jenkins Slave"
  homepage "https://github.com/riboseinc/bsd-jenkins-slaves"
  # url "https://github.com/riboseinc/rnp/archive/0.8.0.tar.gz"
  # sha256 "b61ae76934d4d125660530bf700478b8e4b1bb40e75a4d60efdb549ec864c506"
  head "https://github.com/riboseinc/bsd-jenkins-slaves.git"

  # This is a custom requirement
  depends_on :vagrant

  devel do
    version '0.1.0'
  end

  def install
#     (bin/"jenkins-freebsd-up").write <<-EOS.undent
# #!/bin/bash
# export PATH=$PATH:/usr/local/bin
# if [ $1 == "--version"]; then
#   which vagrant
#   exit 0
# fi
#
# sudo -u /var/log/freebsd-jenkins-slave.log vagrant up --type headless
# EOS
#
#     bin.install (bin/"jenkins-freebsd-up")
#
    cp_r buildpath, prefix
  end

  plist_options startup: false

  def plist; <<-EOS.undent
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <dict>
      <key>SuccessfulExit</key>
      <false/>
    </dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/bin/vagrant</string>
      <string>up</string>
      <string>--type</string>
      <string>headless</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>#{target_prefix}/freebsd</string>
    <key>StandardErrorPath</key>
    <string>/var/log/jenkins-slave-freebsd.log</string>
    <key>StandardOutPath</key>
    <string>/var/log/jenkins-slave-freebsd.log</string>
  </dict>
</plist>
    EOS
  end

  def target_prefix
    "/opt/jenkins-slave-freebsd"
  end

  def plist_name
    "com.ribose.jenkins.slave-freebsd"
  end

  def caveats; <<-EOS.undent
    You need to configure launchctl to run freebsd-jenkins-slave.
    run:
      sudo mkdir -m 755 -p #{target_prefix}/bin
      sudo chown -R root:wheel #{target_prefix}
      # sudo install -m 500 -g wheel -o root #{bin/"jenkins-freebsd-up"} #{target_prefix}/bin

    Ensure that `/opt/freebsd-jenkins-slave/bin` is in your PATH and is set before `/usr/local/bin`. E.g.:
      PATH=/opt/freebsd-jenkins-slave/bin:/usr/local/bin

    To load #{name} at startup, activate the included LaunchDaemon:

    If this is your first install, automatically load on startup with:
      sudo install -m 600 -g wheel -o root #{prefix/(plist_name+".plist")} /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/#{plist_name}.plist

    If this is an upgrade and you already have the plist loaded:
      sudo launchctl unload /Library/LaunchDaemons/#{plist_name}.plist
      sudo install -m 600 -g wheel -o root #{prefix/(plist_name+".plist")} /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/#{plist_name}.plist

    EOS
  end

  test do
    # system "jenkins-freebsd-up", "--version"
  end
end
