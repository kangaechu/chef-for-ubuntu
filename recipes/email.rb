cookbook_file "/home/gitlab/gitlab/config/initializers/smtp_enable_tls.rb" do
  source "smtp_enable_tls.rb"
  mode 0664
  owner "gitlab"
  group "gitlab"
end

template "/home/gitlab/gitlab/config/initializers/smtp_settings.rb" do
  source "smtp_settings.rb.erb"
  mode 0664
  owner "gitlab"
  group "gitlab"
  variables(
    :email => data_bag_item('services', 'gitlab')['email'],
  )
end

execute "change rails production config from sendmail to smtp" do
  command "sudo sed -i 's/:sendmail/:smtp/' /home/gitlab/gitlab/config/environments/production.rb"
end