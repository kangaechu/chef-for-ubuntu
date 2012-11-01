service "nginx" do
  action :restart
end

execute "Gitlab start" do
  user 'root'
  group 'root'
  command "/etc/init.d/gitlab start"
end