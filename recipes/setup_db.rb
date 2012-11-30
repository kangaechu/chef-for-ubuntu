execute "delete db" do
  user "gitlab"
  group "gitlab"
  cwd "/home/gitlab/gitlab"
  command "bundle exec rake db:drop RAILS_ENV=production"
  not_if { node.attribute?("db_setup") }
end

execute "create db and load schema" do
  user "gitlab"
  group "gitlab"
  cwd "/home/gitlab/gitlab"
  command "bundle exec rake db:setup RAILS_ENV=production"
  not_if { node.attribute?("db_setup") }
end

execute "seed db" do
  user "gitlab"
  group "gitlab"
  cwd "/home/gitlab/gitlab"
  command "bundle exec rake db:seed_fu RAILS_ENV=production"
  notifies :create, "ruby_block[db_setup]", :immediately
  not_if { node.attribute?("db_setup") }
end

ruby_block "db_setup" do
  block do
    node.set['db_setup'] = true
    node.save
  end
  action :nothing
end

# execute "run status" do
#   cwd "/home/gitlab/gitlab"
#   command "sudo bundle exec rake gitlab:app:status RAILS_ENV=production"
# end