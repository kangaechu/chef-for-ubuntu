service "nginx" do
  action :restart
end

status = `sudo service gitlab status`
if "Gitlab service is not running." == status
  print("Starting gitlab service")
  print(".")
  `sudo service gitlab start`
else
  `sudo service gitlab restart`
end