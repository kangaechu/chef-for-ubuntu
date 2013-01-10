service "nginx" do
  action :start
end

ruby_block "Start gitlab" do
  block do
    print("Starting gitlab service")
    begin
      print(".")
      sleep(5)
      status = `sudo service gitlab status`
    end while "Gitlab service is not running." == status
    puts(" done.")
  end
  action :nothing
end
