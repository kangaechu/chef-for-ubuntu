service "nginx" do
  action :start
end

puts("Starting gitlab service")
`sudo service gitlab start`
begin
  print(".")
  sleep(1)
  status = `sudo service gitlab status`
end while "Gitlab service is not running." == status
