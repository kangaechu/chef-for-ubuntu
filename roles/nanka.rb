name "nanka"
description ""
run_list(
  "role[base]",
  "recipe[build-essential]",
  "recipe[iptables]",
  "recipe[ssh]",
  "recipe[apache2]",
  "recipe[mysql]",
  "recipe[php]",
  "recipe[wordpress]",
  "recipe[virtualbox]"
)

default_attributes({
  :role  => "nanka",
})

override_attributes({
  :mysql => {
  	:server_debian_password => "test",
  	:server_root_password => "test",
  	:server_repl_password => "test"
  }
})
