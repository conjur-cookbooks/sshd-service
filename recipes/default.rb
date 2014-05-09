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

node.sshd_service.packages.each{|p| 

  unless ancient_ubuntu and p=="openssh-server"
    package p
  else
    # by default chef does not upgrade openssh-server installed from stock repo
    package p do 
      action :upgrade
    end 
  end
}

# https://github.com/AndreyChernyh/openssh/commit/ee011fdda086547c876bceff79f63d751d0893b9
ssh_service_provider = Chef::Provider::Service::Upstart if 'ubuntu' == node['platform'] && Chef::VersionConstraint.new('>= 13.10').include?(node['platform_version'])


service node.sshd_service.service do
  supports :restart => true
  provider ssh_service_provider
end
