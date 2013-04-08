name "base"
description ""
run_list(
  "recipe[common]"
)

default_attributes({
  :role                => "base",
})
