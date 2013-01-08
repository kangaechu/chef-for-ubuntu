service "nginx" do
  action :start
end

begin
  print("Starting gitlab service")
  print(".")
  status = `sudo service gitlab status`
  `sudo service gitlab start`
  sleep(5)
end while "Gitlab service is not running." == status