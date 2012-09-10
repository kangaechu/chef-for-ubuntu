execute "start nginx" do
  command "sudo service nginx restart"
end

execute "start gitlab" do # TODO Better to start as gitlab user but no repo visibility.
  command "service gitlab start"
end