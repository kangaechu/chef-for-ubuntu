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
  mode "0744"
  owner "gitlab"
  group "gitlab"
  action :create
  recursive true
end

# gitolite dir
directory "/mnt/ebs/dotgitolite" do
  mode "0755"
  owner "git"
  group "git"
  action :create
  recursive true
end

# repositories symlink (need to do before gitolite setup)
link "/home/git/repositories"
  to "/mnt/ebs/repositories "
  owner "git"
  group "git"
end

# .gitolite.rc symlink back from EBS (need when status checks 'UMASK for .gitolite.rc' with relative path)
link "/mnt/ebs/.gitolite.rc"
  to "/home/git/.gitolite.rc"
  owner "git"
  group "git"
end

# uploads symlink are later (in the script), first need to clone gitlab repo

# ssh symlink
link "/home/gitlab/.ssh"
  to "/mnt/ebs/dotssh"
  owner "gitlab"
  group "gitlab"
end

execute "generate ssh key for gitlab to access gitolite"
  command "sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa"
end

# second symlink for gitolite setup, permissions should already be 0644
link "/home/git/gitlab.pub"
  to "/mnt/ebs/dotssh/gitlab.pub"
  owner "gitlab"
  group "gitlab"
end

# gitolite symlink
link "/home/git/.gitolite"
  to "/mnt/ebs/dotgitolite"
  owner "git"
  group "git"
end
