service "nginx" do
  action :restart
end

service "gitlab restart" do
  service_name "gitlab"
  provider Chef::Provider::Service::Init::Debian
  action :restart
end
