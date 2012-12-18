execute "rewrite hooks in all projects to symlink gitolite hook" do
  command "sudo -u git -H /home/gitlab/gitlab/lib/support/rewrite-hooks.sh"
end
