include_recipe "aws"
aws = data_bag_item("services", "gitlab")["aws"]

# https://github.com/opscode/cookbooks/tree/master/aws/#ebs_volumerb

aws_ebs_volume "ebs_volume_new" do
  aws_access_key aws['access_key_id']
  aws_secret_access_key aws['secret_access_key']
  size 50 # GB
  device "/dev/sdi" # Shows up as something different.
  description "repos-and-attachments"
  action [ :create, :attach ]
end

# aws_ebs_volume "ebs_volume_from_snapshot" do
#   aws_access_key aws['aws_access_key_id']
#   aws_secret_access_key aws['aws_secret_access_key']
#   size 50 # GB
#   device "/dev/sdi"
#   description "repos-and-attachments"
#   snapshot_id "snap-ABCDEFGH"
#   action [ :create, :attach ]
# end

# execute "remove if already mounted" do
#   command "umount /mnt"
# end

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