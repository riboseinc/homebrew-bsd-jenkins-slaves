require File.expand_path("../../requirements/vagrant_requirement.rb", __FILE__)
require File.expand_path("../../requirements/virtualbox_requirement.rb", __FILE__)

module BsdJenkinsSlave

  def bsd_flavor
    raise StandardError.new "This is an ABSTRACT FORMULA, use one of its flavors."
  end

  def bsd_flavor_caps
    self.bsd_flavor.upcase
  end

  def bsd_flavor_lower
    self.bsd_flavor.downcase
  end

  def install
    (bin/"jenkins-#{bsd_flavor_lower}-up").write <<-EOS.undent
      #!/bin/bash
      export PATH=$PATH:/usr/local/bin

      if [ "$1" = "--version" ]; then
        which vagrant || exit 1
        exit 0
      fi

      cd #{opt_prefix}/#{bsd_flavor_lower}
      vagrant up
    EOS

    # bin.install (bin/"jenkins-#{bsd_flavor_lower}-up")
    cp_r (buildpath/"#{bsd_flavor_lower}"), prefix
    cp_r (buildpath/"scripts"), prefix
  end

#   def plist; <<-EOS.undent
# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
#   <dict>
#     <key>KeepAlive</key>
#     <dict>
#       <key>SuccessfulExit</key>
#       <false/>
#     </dict>
#     <key>Label</key>
#     <string>#{plist_name}</string>
#     <key>ProgramArguments</key>
#     <array>
#       <string>#{opt_bin/"jenkins-#{bsd_flavor_lower}-up"}</string>
#     </array>
#     <key>RunAtLoad</key>
#     <true/>
#     <key>WorkingDirectory</key>
#     <string>#{opt_prefix}/#{bsd_flavor_lower}</string>
#     <key>StandardErrorPath</key>
#     <string>/var/log/jenkins-slave-#{bsd_flavor_lower}.log</string>
#     <key>StandardOutPath</key>
#     <string>/var/log/jenkins-slave-#{bsd_flavor_lower}.log</string>
#     <key>SessionCreate</key>
#     <true/>
#   </dict>
# </plist>
#     EOS
#   end

  # VBoxManage lives in /usr/local/bin, we need to include the PATH
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
    <key>EnvironmentVariables</key>
    <dict>
      <key>HOME</key>
      <string>#{File.expand_path("~")}</string>
      <key>PATH</key>
      <string>/usr/local/sbin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
      <key>JENKINS_URL</key>
      <string>REPLACE_ME_JENKINS_URL</string>
      <key>JENKINS_SECRET</key>
      <string>REPLACE_ME_JENKINS_SECRET</string>
    </dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/bin/vagrant</string>
      <string>up</string>
      <string>--provider</string>
      <string>virtualbox</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>#{opt_prefix}/#{bsd_flavor_lower}</string>
    <key>StandardErrorPath</key>
    <string>#{var}/log/jenkins-slave-#{bsd_flavor_lower}.log</string>
    <key>StandardOutPath</key>
    <string>#{var}/log/jenkins-slave-#{bsd_flavor_lower}.log</string>
    <key>SessionCreate</key>
    <true/>
  </dict>
</plist>
    EOS
  end

  def target_prefix
    "/opt/jenkins-slave-#{bsd_flavor_lower}"
  end

  def plist_name
    "com.ribose.jenkins.slave-#{bsd_flavor_lower}"
  end

  # If have bin/ add these lines:
  # sudo install -m 500 -g wheel -o root #{bin/"jenkins-#{bsd_flavor_lower}-up"} #{target_prefix}/bin
  #
  # Ensure that `/opt/#{bsd_flavor_lower}-jenkins-slave/bin` is in your PATH and is set before `/usr/local/bin`. E.g.:
  #   PATH=/opt/#{bsd_flavor_lower}-jenkins-slave/bin:/usr/local/bin
  #
  # You need to configure launchctl to run #{bsd_flavor_lower}-jenkins-slave.
  # run:
  #   sudo mkdir -m 755 -p #{target_prefix}
  #   sudo chown -R root:wheel #{target_prefix}
  #   sudo cp -a #{opt_prefix/"#{bsd_flavor_lower}"} #{target_prefix}
  #   sudo cp -a #{opt_prefix/"scripts"} #{target_prefix}
  #
  # To load #{name} at startup, activate the included LaunchDaemon:
  #
  # If this is your first install, automatically load on startup with:
  #   sudo install -m 600 -g wheel -o root #{opt_prefix/(plist_name+".plist")} /Library/LaunchDaemons
  #   sudo launchctl load -w /Library/LaunchDaemons/#{plist_name}.plist
  #
  # If this is an upgrade and you already have the plist loaded:
  #   sudo launchctl unload /Library/LaunchDaemons/#{plist_name}.plist
  #   sudo install -m 600 -g wheel -o root #{opt_prefix/(plist_name+".plist")} /Library/LaunchDaemons
  #   sudo launchctl load -w /Library/LaunchDaemons/#{plist_name}.plist

  def caveats; <<-EOS.undent
    WARNING:
      You must configure the JENKINS_URL and JENKINS_SECRET environment
      variables in this file for it to work:

    Step 1: Configure your JENKINS_URL / JENKINS_SECRET.

    export #{bsd_flavor_caps}_SLAVE_PLIST=#{opt_prefix/(plist_name+".plist")}
    sed -i.bak \\
      's/REPLACE_ME_JENKINS_URL/https:\\/\\/my-jenkins.com\\/computer\\/agentname\\/slave-agent.jnlp// \\
      ${#{bsd_flavor_caps}_SLAVE_PLIST}

    sed -i.bak \\
      's/REPLACE_ME_JENKINS_SECRET/bd38130d1412b54287a00a3750bd100c/' \\
      ${#{bsd_flavor_caps}_SLAVE_PLIST}

    Step 2: Start VM (Vagrant+VirtualBox) via brew services

      If you want to start on machine boot, use `root`.

      sudo brew services start riboseinc/bsd-jenkins-slaves/#{bsd_flavor_lower}-jenkins-slave

      If you want to start on login, just do this.

      brew services start riboseinc/bsd-jenkins-slaves/#{bsd_flavor_lower}-jenkins-slave

    If you want to remove the VM:

      cd #{opt_prefix}/#{bsd_flavor_lower}
      vagrant destroy -f

    *Ignore what brew tells you below!*
    -------------vvvvvvv-------------
     \------------vvvvv------------/
      \------------vvv------------/
       \------------v------------/
    EOS
  end

end
