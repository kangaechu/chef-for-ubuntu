execute "create git user" do
  command "adduser --system --shell /bin/sh --gecos 'git version control' --group --disabled-password --home /home/git git"
end

execute "create gitlab user" do
  command "adduser --disabled-login --gecos 'gitlab system' gitlab"
end

execute "add gitlab to git group" do
  command "usermod -a -G git gitlab"
end