execute "empty EBS drive" do
  command "rm -rf /mnt/ebs/*"
end

# EBS repositories dir (git user needs to exist)
directory "/mnt/ebs/repositories" do
  mode "0770"
  owner "git"
  group "git"
  action :create
  recursive true
end

# EBS uploads dir
directory "/mnt/ebs/uploads" do
  mode "0755"
  owner "gitlab"
  group "gitlab"
  action :create
  recursive true
end

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

execute "run status" do
  cwd "/home/gitlab/gitlab"
  command "sudo bundle exec rake gitlab:app:status RAILS_ENV=production"
end