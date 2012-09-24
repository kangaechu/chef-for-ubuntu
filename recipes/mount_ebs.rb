include_recipe "aws"
aws = data_bag_item("services", "gitlab")["aws"]
ebs = data_bag_item("services", "gitlab")["ebs"]

# https://github.com/opscode/cookbooks/tree/master/aws/#ebs_volumerb

aws_ebs_volume "ebs_volume_new" do
  aws_access_key aws['access_key_id']
  aws_secret_access_key aws['secret_access_key']
  size ebs['size'] # GB
  device "/dev/sdi" # Shows up with s replaced by xv
  description "repos-and-attachments"
  action [ :create, :attach ]
end

execute "format EBS drive" do
  command "mkfs.ext4 /dev/xvdi"
  not_if {File.exists?("/mnt/ebs")}
end

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