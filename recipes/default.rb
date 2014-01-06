node.sshd_service.packages.each{|p| package p }

service node.sshd_service.service do
  supports :restart => true
end
