service "nginx" do
  action :start
end

print("Starting gitlab service")
`sudo service gitlab start`
print(".") && sleep(1) while "Gitlab service is not running." == `sudo service gitlab status`
