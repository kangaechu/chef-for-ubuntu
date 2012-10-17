service "nginx" do
  action :restart
end

service "gitlab start" do
  service_name "gitlab"
  provider Chef::Provider::Service::Init::Debian
  action :start
end

service "gitlab status" do
  service_name "gitlab"
  provider Chef::Provider::Service::Init::Debian
  action :status
end

# execute "Gitlab start" do
#   user 'root'
#   group 'root'
#   command "service gitlab start"
# end

# execute "Gitlab status" do
#   user 'root'
#   group 'root'
#   command "service gitlab status"
# end
