#
# Chef solo configuration file.
# See http://docs.opscode.com/config_rb_solo.html
#

log_level :debug
cookbook_path ["/var/chef/cookbooks"]
data_bag_path "/var/chef/data_bags"
role_path "/var/chef/roles"
