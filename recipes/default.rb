ancient_ubuntu=('ubuntu' == node['platform'] and Chef::VersionConstraint.new('<= 12.04').include?(node['platform_version']))

if ancient_ubuntu
  # use backports from our own repo
  apt_repository "conjur-stable" do
    uri "http://ppa.launchpad.net/conjur/stable/ubuntu"
    distribution "precise"
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "B22D14E6"
  end
  # enforce apt-get update to catch new repo
  execute "apt-get-update-periodic" do
    command "apt-get update -y"
  end
end

node['sshd_service']['packages'].each{|p|
  unless ancient_ubuntu and p=="openssh-server"
    package p
  else
    # by default chef does not upgrade openssh-server installed from stock repo
    package p do
      action :upgrade
    end
  end
}

service node['sshd_service']['service'] do
  action [:enable, :start]
  supports :restart => true
end
