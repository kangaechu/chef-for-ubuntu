service "nginx" do
  action :restart
end

service "gitlab" do
  action :restart
end