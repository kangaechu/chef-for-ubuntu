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
  user "gitlab"
  group "gitlab"
  command "service gitlab start"
end

execute "run status" do
  cwd "/home/gitlab/gitlab"
  command "sudo bundle exec rake gitlab:app:status RAILS_ENV=production"
end