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
