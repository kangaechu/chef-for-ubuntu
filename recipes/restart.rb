service "nginx" do
  action :restart
end

service "start gitlab" do
  service_name "gitlab"
  action :start
end