execute "migrate the db" do
  cwd "/home/gitlab/gitlab"
  command "sudo -u gitlab bundle exec rake db:migrate RAILS_ENV=production"
end