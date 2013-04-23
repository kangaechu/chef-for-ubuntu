name "nanka"
description ""
run_list(
  "role[base]",
  "recipe[chef-solo-search]",
  "recipe[users::sysadmins]",
  "recipe[build-essential]",
  "recipe[iptables]",
  "recipe[openssh]",
  "recipe[openssh::iptables]",
  "recipe[apache2]",
  "recipe[apache2::iptables]",
  "recipe[mysql]",
  "recipe[php]",
  "recipe[wordpress]",
  "recipe[application]",
  "recipe[ruby]",
  "recipe[rake]",
  "recipe[passenger_apache2]",
  "recipe[redmine]",
  "recipe[virtualbox]",
  "recipe[gitlab]"
)

default_attributes({
  :role  => "nanka",
})

override_attributes({
  :openssh => {
    :server => {
      :port => "10022",
      :password_authentication => "no",
      :permit_root_login => "no"
    }
  },
  :mysql => {
    :server_debian_password => "test",
    :server_root_password => "test",
    :server_repl_password => "test"
  },
  :passenger => {
    :manage_module_conf => false,
    :install_method => "package",
    :package => {
      :name => "libapache2-mod-passenger",
      :version => nil
    }
  },
  :sudo => {
    :sudoers_groups => ["sudo"]
  },
  :wordpress => {
    :server_aliases => ["blog", "www"]
  }
})
