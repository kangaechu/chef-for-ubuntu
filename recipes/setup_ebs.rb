# repositories dir (git user needs to exist)
directory "/mnt/ebs/repositories" do
  mode "0770"
  owner "git"
  group "git"
  action :create
  recursive true
end

# uploads dir
directory "/mnt/ebs/uploads" do
  mode "0755"
  owner "gitlab"
  group "gitlab"
  action :create
  recursive true
end

# ssh dir
directory "/mnt/ebs/dotssh" do
  mode "0755"
  owner "gitlab"
  group "gitlab"
  action :create
  recursive true
end

# repositories symlink (need to do before gitolite setup)
link "/home/git/repositories" do
  to "/mnt/ebs/repositories"
end

# .gitolite.rc symlink back from EBS (need when status checks 'UMASK for .gitolite.rc' with relative path)
link "/mnt/ebs/.gitolite.rc" do
  to "/home/git/.gitolite.rc"
end

# uploads symlink are later (in the script), first need to clone gitlab repo

# ssh symlink
link "/home/gitlab/.ssh" do
  to "/mnt/ebs/dotssh"
end

execute "generate ssh key for gitlab to access gitolite" do
  command "sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa"
not_if {File.exists?("/home/gitlab/.ssh/id_rsa")}
end

# second symlink for gitolite setup, permissions should already be 0644
# TODO remove this symlink and run setup with normal key
link "/home/git/gitlab.pub" do
  to "/mnt/ebs/dotssh/id_rsa.pub"
end
