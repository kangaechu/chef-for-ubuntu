include_recipe "aws"
aws = data_bag_item("services", "gitlab")["aws"]
eip = data_bag_item("services", "gitlab")["eip"]

# https://github.com/opscode/cookbooks/tree/master/aws/#elastic_iprb

aws_elastic_ip "eip_fqdn" do
  aws_access_key aws['access_key_id']
  aws_secret_access_key aws['secret_access_key']
  ip eip['fqdn']
  action :associate
end