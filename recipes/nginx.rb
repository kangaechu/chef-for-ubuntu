# sudo apt-get install -y nginx
package "nginx" do
  action :install
end

file "/etc/ssl/gitlab.com.key" do
  content data_bag_item('services', 'gitlab')["certificate_key"]
  owner "root"
  group "root"
  mode 0600
end

file "/etc/ssl/gitlab.com.crt" do
  content data_bag_item('services', 'gitlab')["certificate_chained"]
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
    :ssl => data_bag_item('services', 'gitlab')['ssl'],
  )
end

link "/etc/nginx/sites-enabled/gitlab" do
  to "/etc/nginx/sites-available/gitlab"
end