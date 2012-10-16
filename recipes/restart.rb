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
  command "service gitlab start"
end