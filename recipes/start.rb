service "nginx" do
  action :start
end

print("Starting gitlab service")
# bash "start gitlab" do
#   code <<-EOH
#     sudo service gitlab start
#   EOH
# end
service "gitlab" do
  action :start
end

begin
  print(".")
  status = `sudo service gitlab status`
  sleep(5)
end while "Gitlab service is not running." == status
puts(" done.")
