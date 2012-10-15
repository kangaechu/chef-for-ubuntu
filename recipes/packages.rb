# Install all the packages that are needed.

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
end

%w(git git-core wget curl gcc checkinstall libxml2-dev libxslt-dev sqlite3 libsqlite3-dev libcurl4-openssl-dev libreadline-gplv2-dev libc6-dev libssl-dev libmysql++-dev make build-essential zlib1g-dev libicu-dev redis-server openssh-server python-dev python-pip libyaml-dev mysql-client).each do |pkg|
  package pkg
end

python_pip "pygments" do
  action :install
  retries 3
  retry_delay 2
end

gem_package "bundler" do
  action :install
end

gem_package "charlock_holmes" do
  version "0.6.8"
  action :install
end