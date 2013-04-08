name "nanka"
description ""
run_list(
  "role[base]",
  "recipe[iptables]",
  "recipe[ssh]",
  "recipe[httpd]",
  "recipe[mysql]",
  "recipe[virtualbox]"
)

default_attributes({
  :role  => "nanka",
})

