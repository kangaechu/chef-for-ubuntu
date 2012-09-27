execute "create git user" do
  command "adduser --system --shell /bin/sh --gecos 'git version control' --group --disabled-password --home /home/git git"
  not_if "grep git /etc/passwd"
end

execute "create gitlab user" do
  command "adduser --disabled-login --gecos 'gitlab system' gitlab"
  not_if "grep gitlab /etc/passwd"
end

execute "add gitlab to git group" do
  command "usermod -a -G git gitlab"
  not_if "grep git: /etc/group | grep gitlab"
end

execute "check git user id" do
  command "id -u git | grep 106"
end

execute "check gitlab user id" do
  command "id -u gitlab | grep 1001"
end