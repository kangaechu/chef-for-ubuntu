# repositories dir (git user needs to exist)
directory "/mnt/ebs/repositories" do
  mode "6770"
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

# gitlab tmp dir
directory "/mnt/ebs/gitlab_tmp" do
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

# tmp symlink are later (in the script), first need to clone gitlab repo

# dotssh symlink
link "/home/gitlab/.ssh" do
  to "/mnt/ebs/dotssh"
end

execute "generate ssh key for gitlab to access gitolite" do
  command "sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa"
not_if {File.exists?("/home/gitlab/.ssh/id_rsa")}
end

def write_key(file_name, file_mode, file_content)
  file "/etc/ssh/#{file_name}" do
    content file_content
    owner "root"
    group "root"
    mode file_mode
  end
end

%w(dsa rsa ecdsa).each do |ssh_standard|
  private_filename = "ssh_host_#{ssh_standard}_key"
  write_key(private_filename, 0600, data_bag_item('ssh', 'gitlab')[private_filename])
  public_filename = "#{private_filename}.pub"
  write_key(public_filename, 0644, data_bag_item('ssh', 'gitlab')[public_filename])
end

service "ssh" do
  action :restart
end

# second symlink for gitolite setup, permissions should already be 0644
# TODO remove this symlink and run setup with normal key
link "/home/git/gitlab.pub" do
  to "/mnt/ebs/dotssh/id_rsa.pub"
end
