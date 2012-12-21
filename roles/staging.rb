name "staging"
description "Staging role for this cookbook"
run_list(
  "role[gitlab]",
  #"recipe[gitlab::setup_db]",
  #"recipe[gitlab::attach_eip]",
  "recipe[gitlab::restart]"
)
default_attributes({
  # All in databag
})