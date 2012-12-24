papertrail = data_bag_item('services', 'gitlab')['papertrail']

execute "add papertrail to the syslog" do
  command "echo '*.* @logs.papertrailapp.com:#{papertrail['port']}' | sudo tee -a /etc/rsyslog.conf"
not_if "grep 'logs.papertrailapp.com' /etc/rsyslog.conf"
end

service "rsyslog" do
  action :restart
end

gem_package "remote_syslog" do
  action :install
end

# Temporary fix until https://github.com/dosire/cookbook-gitlab/issues/61#issuecomment-11656798 is resolved
execute "Temp fix for moneta version problem"
  command "gem install moneta -v '~> 0.6.0' && gem uninstall moneta -v '>= 0.7.0'"
end

template "/etc/log_files.yml" do
  source "log_files.yml.erb"
  mode 0644
  owner "root"
  group "root"
  variables(:papertrail => papertrail)
end

execute "start the gem" do # Not sure if this is idempotent.
  command "sudo remote_syslog"
  not_if "ps aux | grep remote_syslog | grep -v grep"
end