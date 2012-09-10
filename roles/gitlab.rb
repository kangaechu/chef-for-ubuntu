# Based on:
# https://github.com/gitlabhq/gitlab-recipes/blob/master/install/debian_ubuntu.sh ebf8bd031e4b3283b9967d7816b06994fa04a0b2
# https://github.com/gitlabhq/gitlab-recipes/blob/master/install/debian_ubuntu_aws.sh 8d8385f7e13ac1175bad2e5221d462353b67cb6c

# TODO put database.yml in shared and symlink to it
# TODO convert install script to chef commands
# TODO create nginx config from template

name "gitlab"
description "Base role for this cookbook"
run_list(
  "recipe[gitlab::create_users]", # needed to setup ebs ownership
  "recipe[gitlab::mount_ebs]",
  "recipe[gitlab::setup_ebs]",
  # - Create recipe symlink (first install only, otherwise different place)
  "recipe[gitlab]",
  "recipe[gitlab::setup_db]"# , # first install only
  # - Create recipe symlink (later install only, otherwise different place)
  #{ }"recipe[gitlab::startup]"
)
default_attributes({
  # All in databag
})
