name "production"
description "Production role for this cookbook"
run_list(
  "role[gitlab]",
  "recipe[gitlab::start]"
)
default_attributes({
  # All in databag
})