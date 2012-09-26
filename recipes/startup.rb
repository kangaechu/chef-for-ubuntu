service "nginx" do
  action :restart
end

service "gitlab" do
  action :start
end
