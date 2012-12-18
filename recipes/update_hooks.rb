execute "rewrite hooks in all projects to symlink gitolite hook" do
  command "sudo -u git -H /home/gitlab/gitlab/lib/support/rewrite-hooks.sh"
end

execute "enable automerge" do
  cwd "/home/gitlab/gitlab"
  command "sudo -u gitlab -H bundle exec rake gitlab:app:enable_automerge RAILS_ENV=production"
end