node.sshd_service.packages.each{|p| package p }

# https://github.com/AndreyChernyh/openssh/commit/ee011fdda086547c876bceff79f63d751d0893b9
ssh_service_provider = Chef::Provider::Service::Upstart if 'ubuntu' == node['platform'] && Chef::VersionConstraint.new('>= 13.10').include?(node['platform_version'])

service node.sshd_service.service do
  supports :restart => true
  provider ssh_service_provider
end
