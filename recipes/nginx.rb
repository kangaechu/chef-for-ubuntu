# sudo apt-get install -y nginx
package "nginx" do
  action :install
end

template "/etc/nginx/sites-available/gitlab" do
  source "gitlab.erb"
  mode 0664
  owner "root"
  group "root"
  variables(
    :listen_ip => `wget -qO- http://instance-data/latest/meta-data/local-ipv4`.chomp,
    :listen_port => 80
  )
end

link "/etc/nginx/sites-enabled/gitlab" do
  to "/etc/nginx/sites-available/gitlab"
end