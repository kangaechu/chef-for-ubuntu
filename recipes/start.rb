service "nginx" do
  action :start
end

begin
  print("Starting gitlab service")
  print(".")
  status = `service gitlab status`
  service "gitlab" do
    action :start
  end
  sleep(5)
end while "Gitlab service is not running." == status