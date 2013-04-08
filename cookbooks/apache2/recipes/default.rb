#
# = apache2
#

#
# Package install
#
package "apache2" do
  action :install
end

#
# command
#
service "apache2" do
  action [:enable, :start]
end

# open iptables port
iptables_rule "apache2"
