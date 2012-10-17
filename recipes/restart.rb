service "nginx" do
  action :restart
end

# service "gitlab start" do
#   service_name "gitlab"
#   provider Chef::Provider::Service::Init::Debian
#   action :start
# end

execute "Gitlab start" do
  user 'root'
  group 'root'
  command "/usr/bin/nohup sh -c 'service gitlab start >> /home/gitlab/gitlab/log/nohup.log' &>/dev/null </dev/null &"
end

execute "Gitlab status" do
  user 'root'
  group 'root'
  command "service gitlab status >> /home/gitlab/gitlab/log/nohup.log"
end
