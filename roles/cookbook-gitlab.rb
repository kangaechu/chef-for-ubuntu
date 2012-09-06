name "cookbook-gitlab"
description "Base role for this cookbook"
run_list(
  "recipe[gitlab]"
)
default_attributes({
  # All in databag
})
