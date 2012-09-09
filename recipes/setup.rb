execute "delete db" do
  user "gitlab"
  group "gitlab"
  cwd "/home/gitlab/gitlab"
  command "bundle exec rake db:drop RAILS_ENV=production"
end

execute "create db and load schema" do
  user "gitlab"
  group "gitlab"
  cwd "/home/gitlab/gitlab"
  command "bundle exec rake db:setup RAILS_ENV=production"
end

execute "seed db" do
  user "gitlab"
  group "gitlab"
  cwd "/home/gitlab/gitlab"
  command "bundle exec rake db:seed_fu RAILS_ENV=production"
end

execute "start service" do
  command "sudo service gitlab start"
end

