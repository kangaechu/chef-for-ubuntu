name "nanka"
description ""
run_list(
  "role[base]",
  "recipe[build-essential]",
  "recipe[chef-solo-search]",
  #"recipe[users::sysadmins]",
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
  #"recipe[virtualbox]",
  "recipe[database::mysql]",
  "recipe[mysql::server]",
  "recipe[zabbix]",
  "recipe[zabbix::database]",
  "recipe[zabbix::server]",
  "recipe[gitlab]",
  "recipe[backup]",
  "recipe[openldap::master]",
  "recipe[openldap::client]",
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
    :server_debian_password => "mysql",
    :server_root_password => "mysql",
    :server_backup_password => "mysql",
    :server_repl_password => "mysql"
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
    :server_aliases => [],
    :repourl => "http://ja.wordpress.org/",
    :version => "3.5.1-ja",
  },
  :redmine => {
    :basedir => "/opt"
  },
  :zabbix => {
    :agent => {
      :servers => ["localhost"],
    },
    :server => {
      :install => true,
      :configure_options => [ "--with-libcurl","--with-net-snmp"],
    },
    :web => {
      :install => true,
    },
    :database => {
      :dbpassword => "zabbix",
    },
  },
  :gitlab => {
    :gitlab_shell_branch => "v1.4.0",
    :gitlab_branch => "5-2-stable",
    :db => {
      :password => "gitlabhq_prod"
    },
    :ldap => {
      :enabled => true,
      :method => "plain",
      :port => 389,
      :uid => "mail",
    },
  },
  :backup => {
    :user => "ubuntu",
  },
  :openldap => {
    :rootpw => "{SSHA}9uZW1EqGwmjmOH44FP5J2KDw2rCDBP0O",
  },
})
