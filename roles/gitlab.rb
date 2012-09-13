# Based on:
# https://github.com/gitlabhq/gitlabhq/blob/master/doc/installation.md ad3a88cfd34aeed5ed69b4056e393580a686fb09
# https://github.com/gitlabhq/gitlab-recipes/blob/master/install/debian_ubuntu.sh ebf8bd031e4b3283b9967d7816b06994fa04a0b2
# https://github.com/gitlabhq/gitlab-recipes/blob/master/install/debian_ubuntu_aws.sh 8d8385f7e13ac1175bad2e5221d462353b67cb6c

# TODO put database.yml in shared and symlink to it
# TODO convert install script to chef commands
# TODO create nginx config from template

name "gitlab"
description "Base role for this cookbook"
run_list(
  "recipe[gitlab::create_users]", # need users for setup_ebs ownership
  "recipe[gitlab::mount_ebs]", # always mount, can trow away on swap
  "recipe[gitlab::setup_ebs]", # always setup, can trow away on swap
  "recipe[gitlab]",
  "recipe[gitlab::email]",
  "recipe[gitlab::setup_db]", # first install only
  "recipe[gitlab::startup]"
)
default_attributes({
  # All in databag
})
