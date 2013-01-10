service "nginx" do
  action :start
end

ruby_block "Start gitlab" do
  block do
    print("Starting gitlab service")
    begin
      print(".")
      sleep(5)
      status = `sudo service gitlab start`
    end until "Error! Gitlab service unicorn is currently running!" == status.strip
    puts(" done.")
  end
  action :create
end
