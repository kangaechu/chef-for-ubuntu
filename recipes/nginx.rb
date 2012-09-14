# sudo apt-get install -y nginx
package "nginx" do
  action :install
end

ssl_data_bag = data_bag_item('services', 'gitlab')["ssl"]

file "/etc/ssl/gitlab.com.key" do
  content ssl_data_bag["certificate_key"]
  owner "root"
  group "root"
  mode 0600
end

file "/etc/ssl/gitlab.com.crt" do
  content ssl_data_bag["certificate_chained"]
  owner "root"
  group "root"
  mode 0600
end

template "/etc/nginx/sites-available/gitlab" do
  source "gitlab.erb"
  mode 0664
  owner "root"
  group "root"
  variables(
    :ssl => ssl_data_bag,
  )
end

link "/etc/nginx/sites-enabled/gitlab" do
  to "/etc/nginx/sites-available/gitlab"
end