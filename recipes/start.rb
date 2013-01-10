service "nginx" do
  action :start
end

print("Starting gitlab service")
service "gitlab" do
  action :start
end

begin
  print(".")
  sleep(5)
  status = `sudo service gitlab status`
end while "Gitlab service is not running." == status
puts(" done.")
