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

%w(dsa rsa ecdsa).each do |standard|
  execute "copy #{standard} key to the ebs drive if it is empty" do
    command "cp -r /etc/ssh/ssh_host_#{standard}_key /mnt/ebs/ssh/ssh_host_#{standard}_key"
  not_if {File.exists?("/mnt/ebs/ssh/ssh_host_#{standard}_key")}
  end
end

execute "the git user sees the keys from the ebs drive to preserve the fingerprint" do
  command "echo 'Match User git
   HostKey /mnt/ebs/ssh/ssh_host_rsa_key
   HostKey /mnt/ebs/ssh/ssh_host_dsa_key
   HostKey /mnt/ebs/ssh/ssh_host_ecdsa_key' | sudo tee -a /etc/ssh/sshd_config"
not_if "grep 'Match User git' /etc/ssh/sshd_config"
end

# second symlink for gitolite setup, permissions should already be 0644
# TODO remove this symlink and run setup with normal key
link "/home/git/gitlab.pub" do
  to "/mnt/ebs/dotssh/id_rsa.pub"
end
