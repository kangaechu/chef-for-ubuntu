#!/bin/sh

### Prevent fingerprint prompt for localhost ###

echo "Host localhost
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null" | sudo tee -a /etc/ssh/ssh_config

### Install packages ###

sudo apt-get update

sudo apt-get install -y git git-core wget curl gcc checkinstall libxml2-dev libxslt-dev sqlite3 libsqlite3-dev libcurl4-openssl-dev libreadline-gplv2-dev libc6-dev libssl-dev libmysql++-dev make build-essential zlib1g-dev libicu-dev redis-server openssh-server python-dev python-pip libyaml-dev

### EBS commands ###

# Symlink EBS repositories (need to do before gitolite setup)
sudo ln -s /mnt/ebs/repositories /home/git/repositories
sudo chmod -R 770 /home/git/repositories
sudo chown -R git:git /home/git/repositories

# Symlink back from EBS (need when status checks 'UMASK for .gitolite.rc' with relative path)
sudo ln -s /home/git/.gitolite.rc /mnt/ebs/.gitolite.rc
sudo chmod -R 770 /mnt/ebs/.gitolite.rc
sudo chown -R git:git /mnt/ebs/.gitolite.rc

# uploads are later in the script, first need to clone gitlab repo

### Generate ssh key for gitlab to access gitolite

sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa

### Install gitolite ####

# Clone repo
cd /home/git
sudo -H -u git git clone git://github.com/gitlabhq/gitolite /home/git/gitolite

# Gitolite system install
sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; /home/git/gitolite/src/gl-system-install"

# Copy gitlab ssh key
sudo cp /home/gitlab/.ssh/id_rsa.pub /home/git/gitlab.pub
sudo chmod 777 /home/git/gitlab.pub

# Adapt gitolite.rc mask
sudo -u git -H sed -i 's/0077/0007/g' /home/git/share/gitolite/conf/example.gitolite.rc

# Gitolite setup with ssh key
sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; gl-setup -q /home/git/gitlab.pub"

# Test by cloning a repo
sudo -u gitlab -H git clone git@localhost:gitolite-admin.git /tmp/gitolite-admin
sudo rm -rf /tmp/gitolite-admin

# Install packages for gitlab
sudo gem install charlock_holmes --version '0.6.8'
sudo pip install pygments
sudo gem install bundler

# Gitlab clone
sudo su -l gitlab -c "git clone git://github.com/gitlabhq/gitlabhq.git gitlab" # Using master everywhere.
sudo su -l gitlab -c "cd gitlab && mkdir tmp"

# Symlink EBS uploads, gitlab needs to be cloned
sudo ln -s /mnt/ebs/uploads /home/gitlab/gitlab/public/uploads
sudo chown -R gitlab:gitlab /home/gitlab/gitlab/public/uploads
sudo chmod -R 755 /home/gitlab/gitlab/public/uploads

# Copy in Gitlab config
sudo mv /home/ubuntu/gitlab.yml /home/gitlab/gitlab/config/gitlab.yml
sudo chmod 644 /home/gitlab/gitlab/config/gitlab.yml
sudo chown gitlab:gitlab /home/gitlab/gitlab/config/gitlab.yml

# Bundler seems to fail without this and the debian ruby version.
# sudo chmod 775 -R /home/gitlab/gitlab doesn't work
sudo chmod 777 -R /home/gitlab

# Install Gitlab gems, somethings fails due to network so try two times.
sudo su -l gitlab -c "cd gitlab && bundle install --without development test --deployment"
sudo su -l gitlab -c "cd gitlab && bundle install --without development test --deployment"

# Setup gitlab hooks
sudo cp /home/gitlab/gitlab/lib/hooks/post-receive /home/git/share/gitolite/hooks/common/post-receive
sudo chown git:git /home/git/share/gitolite/hooks/common/post-receive

# Tighten gitolite permissions
sudo -u git chmod 750 /home/git/gitolite

# Tighten gitlab config permissions
sudo -u gitlab chmod 660 /home/gitlab/gitlab/config/*.yml

# Install and configure Nginx
sudo apt-get install -y nginx
sudo wget https://raw.github.com/gitlabhq/gitlab-recipes/master/nginx/gitlab -P /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab
sudo sed -i 's/YOUR_SERVER_IP/'`wget -qO- http://instance-data/latest/meta-data/local-ipv4`'/' /etc/nginx/sites-available/gitlab # Set private ip address (public won't work).
sudo sed -i 's/YOUR_SERVER_FQDN/'`wget -qO- http://instance-data/latest/meta-data/public-hostname`'/' /etc/nginx/sites-available/gitlab # Set public dns domain name.

# Configure Unicorn
sudo -u gitlab cp /home/gitlab/gitlab/config/unicorn.rb.orig /home/gitlab/gitlab/config/unicorn.rb

# Create a Gitlab service
sudo wget https://raw.github.com/gitlabhq/gitlab-recipes/master/init.d/gitlab -P /etc/init.d/
sudo chmod +x /etc/init.d/gitlab && sudo update-rc.d gitlab defaults

# Go to gitlab directory by default on next login.
echo 'cd /home/gitlab/gitlab' >> /home/ubuntu/.bashrc
