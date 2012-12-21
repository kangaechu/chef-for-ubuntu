execute "test by cloning a repo" do
  user "gitlab"
  group "git"
  cwd "/home/git"
  command "git clone git@localhost:gitolite-admin.git /tmp/gitolite-admin"
end

directory "/tmp/gitolite-admin" do
  recursive true
  action :delete
end