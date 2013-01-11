service "nginx" do
  action :start
end

ruby_block "Start gitlab" do
  block do
    print("Starting gitlab service")
    system("sudo service gitlab start")
    begin
      print(".")
      sleep(1)
      status = `sudo service gitlab status`
    end while "Gitlab service is not running." == status.strip
    puts(" done.")
  end
  action :create
end
