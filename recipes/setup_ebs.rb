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

# dotssh dir
directory "/mnt/ebs/dotssh" do
  mode "0755"
  owner "gitlab"
  group "gitlab"
  action :create
  recursive true
end

# ssh dir
directory "/mnt/ebs/ssh" do
  mode "0755"
  owner "root"
  group "root"
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

# dotssh symlink
link "/home/gitlab/.ssh" do
  to "/mnt/ebs/dotssh"
end

execute "generate ssh key for gitlab to access gitolite" do
  command "sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa"
not_if {File.exists?("/home/gitlab/.ssh/id_rsa")}
end

execute "move ssh dir out of the way" do
  command "mv /etc/ssh /etc/ssh_old"
not_if {File.exists?("/etc/ssh_old")}
end

execute "make sure the ebs volume contains keys" do
  command "cp -r /etc/ssh_old /mnt/ebs/ssh"
not_if {File.exists?("/mnt/ebs/ssh/ssh_host_ecdsa_key.pub")}
end

# ssh symlink
link "/etc/ssh" do
  to "/mnt/ebs/ssh"
end

# second symlink for gitolite setup, permissions should already be 0644
# TODO remove this symlink and run setup with normal key
link "/home/git/gitlab.pub" do
  to "/mnt/ebs/dotssh/id_rsa.pub"
end
