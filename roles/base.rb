name "base"
description ""
run_list(
  "recipe[common]",
  "recipe[selinux]"
)

default_attributes({
  :role                => "base",
})
