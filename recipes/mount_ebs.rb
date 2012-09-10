# Mount point for EBS
directory "/mnt/ebs" do
  mode "0755"
  owner "root"
  group "root"
  action :create
  recursive true
end

execute "mount EBS drive, use printf to prevent newline" do
  command "mount `cat /etc/fstab | grep /mnt | awk '{printf $1}'` /mnt/ebs"
end