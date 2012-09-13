service "nginx" do
  action :restart
end

service "gitlab" do
  action :start
end

# Had to start again.
service "gitlab" do
  action :restart
end