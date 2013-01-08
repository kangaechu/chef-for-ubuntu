service "nginx" do
  action :start
end

status = `service gitlab status`
puts(status)

service "gitlab" do
  action :start
end