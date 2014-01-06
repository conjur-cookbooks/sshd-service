# Copied from https://github.com/opscode-cookbooks/openssh/blob/master/attributes/default.rb

default['sshd_service']['service'] = case node['platform_family']
  when 'rhel', 'fedora', 'suse', 'freebsd'
    'sshd'
  else
    'ssh'
end

default['sshd_service']['packages'] = case node['platform_family']
  when 'rhel', 'fedora'
    %w[openssh-clients openssh]
  when 'arch', 'suse'
    %w[openssh]
  when 'freebsd'
    %w[]
  else
    %w[openssh-client openssh-server]
end
