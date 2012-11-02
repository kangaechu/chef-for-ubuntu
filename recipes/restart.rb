service "nginx" do
  action :restart
end

service "gitlab restart" do
  service_name "gitlab"
  action :restart
end