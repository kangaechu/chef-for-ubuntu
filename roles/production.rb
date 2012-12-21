name "production"
description "Production role for this cookbook"
run_list(
  "role[gitlab]",
  "recipe[gitlab::restart]"
)
default_attributes({
  # All in databag
})