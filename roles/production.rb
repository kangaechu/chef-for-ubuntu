name "production"
description "Production role for this cookbook"
run_list(
  "role[gitlab]"
)
default_attributes({
  # All in databag
})