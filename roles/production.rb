name "production"
description "Production role for this cookbook"
run_list(
  "role[gitlab]",
  "recipe[gitlab::start]",
  "recipe[gitlab::migrate_db]",
  "recipe[gitlab::gitolite_operations]"
)
default_attributes({
  # All in databag
})