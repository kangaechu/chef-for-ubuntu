execute "start nginx" do
  command "sudo service nginx restart"
end

execute "start gitlab" do
  user "gitlab"
  group "gitlab"
  command "service gitlab start"
end