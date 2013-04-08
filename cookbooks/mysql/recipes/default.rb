#
# = MySQL
#

#
# Package install
#
%w{mysql-client mysql-server}.each do |package_name|
  package package_name do
    action :install
  end
end

#
# Command
#
service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
