include_recipe "aws"
aws = data_bag_item("services", "gitlab")["aws"]

# https://github.com/opscode/cookbooks/tree/master/aws/#ebs_volumerb

aws_ebs_volume "ebs_volume_new" do
  aws_access_key aws['access_key_id']
  aws_secret_access_key aws['secret_access_key']
  size 50 # GB
  device "/dev/sdi" # Shows up with s replaced by xv
  description "repos-and-attachments"
  action [ :create, :attach ]
end

execute "format EBS drive" do
  command "mkfs.ext4 /dev/xvdi"
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

# mount --types ext4 /dev/xvdi /mnt/ebs
mount "/mnt/ebs" do
  device "/dev/xvdi"
  fstype "ext4"
end