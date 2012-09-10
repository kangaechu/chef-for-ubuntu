# Mount point for EBS
directory "/mnt/ebs" do
  mode "0755"
  owner "root"
  group "root"
  action :create
  recursive true
end

execute "mount EBS drive" do
  command "mount /dev/xvdf /mnt/ebs"
end