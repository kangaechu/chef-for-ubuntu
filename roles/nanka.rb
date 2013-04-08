name "nanka"
description ""
run_list(
  "role[base]",
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

