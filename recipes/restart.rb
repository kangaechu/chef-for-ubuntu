service "nginx" do
  action :restart
end

service "gitlab" do
  provider Chef::Provider::Service::Init::Debian
  action :start
end
