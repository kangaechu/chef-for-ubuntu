service "nginx" do
  action :restart
end

service "gitlab restart" do
  provider Chef::Provider::Service::Debian
  pattern "gitlab"
  service_name "gitlab"
  action :restart
end