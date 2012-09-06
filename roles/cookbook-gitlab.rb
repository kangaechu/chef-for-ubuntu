name "cookbook-gitlab"
description "Base role for this cookbook"
run_list(
  "recipe[cookbook-gitlab]"
)
default_attributes({
  # All in databag
})
