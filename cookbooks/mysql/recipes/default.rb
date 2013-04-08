#
# = MySQL
#

#
# Package install
#
execute "yum install mysql" do
  command "yum install -y mysql mysql-server mysql-libs"
  not_if "rpm -q mysql"
end

#
# Configuration files
#
template "/etc/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[mysqld]"
end

#
# Command
#
service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
