ancient_ubuntu=('ubuntu' == node['platform'] and Chef::VersionConstraint.new('<= 12.04').include?(node['platform_version']))

if ancient_ubuntu # add backports repo to catch latest openssh-server
# deb http://ppa.launchpad.net/li69422-staff/backports-for-precise/ubuntu precise main 
# deb-src http://ppa.launchpad.net/li69422-staff/backports-for-precise/ubuntu precise main 
# Signing key:
# 4096R/AEA37004 (What is this?)
# Fingerprint:
# EF8E9E96D7D71790DAB56AC5456821A5AEA37004
  apt_repository "openssh-server-backports" do
    uri "http://ppa.launchpad.net/li69422-staff/backports-for-precise/ubuntu"
    distribution "precise" 
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "AEA37004"
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
