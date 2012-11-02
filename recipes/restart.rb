service "nginx" do
  action :restart
end

service "gitlab restart" do
  provider Chef::Provider::Service::Init::Debian
  notifies :restart, resources(:service => "gitlab")
end