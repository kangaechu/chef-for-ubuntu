#!/bin/sh
# First and second part based on respectively:
# https://github.com/gitlabhq/gitlab-recipes/blob/master/install/debian_ubuntu.sh ebf8bd031e4b3283b9967d7816b06994fa04a0b2
# https://github.com/gitlabhq/gitlab-recipes/blob/master/install/debian_ubuntu_aws.sh 8d8385f7e13ac1175bad2e5221d462353b67cb6c

### EBS commands ###

# Mount EBS and create directories
sudo mkdir -p /mnt/ebs
sudo mount /dev/xvdf /mnt/ebs

# EBS for repositories
sudo mkdir -p /mnt/ebs/repositories # Create a directory if it doesn't exist.

# EBS for uploads
sudo mkdir -p /mnt/ebs/uploads # Create directory if it doesn't exist.
sudo ln -s /mnt/ebs/uploads /home/gitlab/gitlab/public/uploads
sudo chown -R gitlab:gitlab /mnt/ebs/uploads
sudo chmod -R 755 /mnt/ebs/uploads

### Prevent fingerprint prompt for localhost ###

echo "Host localhost
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null" | sudo tee -a /etc/ssh/ssh_config

### First part ###

sudo apt-get update

sudo apt-get install -y git git-core wget curl gcc checkinstall libxml2-dev libxslt-dev sqlite3 libsqlite3-dev libcurl4-openssl-dev libreadline-gplv2-dev libc6-dev libssl-dev libmysql++-dev make build-essential zlib1g-dev libicu-dev redis-server openssh-server python-dev python-pip libyaml-dev

sudo adduser \
  --system \
  --shell /bin/sh \
  --gecos 'git version control' \
  --group \
  --disabled-password \
  --home /home/git \
  git

sudo adduser --disabled-login --gecos 'gitlab system' gitlab

sudo usermod -a -G git gitlab

sudo -H -u gitlab ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa

cd /home/git
sudo -H -u git git clone git://github.com/gitlabhq/gitolite /home/git/gitolite

sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; /home/git/gitolite/src/gl-system-install"
sudo cp /home/gitlab/.ssh/id_rsa.pub /home/git/gitlab.pub
sudo chmod 777 /home/git/gitlab.pub

sudo -u git -H sed -i 's/0077/0007/g' /home/git/share/gitolite/conf/example.gitolite.rc

sudo -u git -H sh -c "PATH=/home/git/bin:$PATH; gl-setup -q /home/git/gitlab.pub"
sudo chmod -R 770 /mnt/ebs/repositories
sudo chown -R git:git /mnt/ebs/repositories

sudo -u gitlab -H git clone git@localhost:gitolite-admin.git /tmp/gitolite-admin
sudo rm -rf /tmp/gitolite-admin

### Second part ###

# Gitlab install
sudo gem install charlock_holmes --version '0.6.8'
sudo pip install pygments
sudo gem install bundler
sudo su -l gitlab -c "git clone git://github.com/gitlabhq/gitlabhq.git gitlab" # Using master everywhere.
sudo su -l gitlab -c "cd gitlab && mkdir tmp"

sudo mv /home/ubuntu/gitlab.yml /home/gitlab/gitlab/config/gitlab.yml
sudo chmod 644 /home/gitlab/gitlab/config/gitlab.yml
sudo chown gitlab:gitlab /home/gitlab/gitlab/config/gitlab.yml

# sudo su -l gitlab -c "cd gitlab/config && cp database.yml.example database.yml"
# sudo sed -i 's/"secure password"/"'$userPassword'"/' /home/gitlab/gitlab/config/database.yml # Insert the mysql root password.
sudo su -l gitlab -c "cd gitlab && bundle install --without development test --deployment"
# sudo su -l gitlab -c "cd gitlab && bundle exec rake gitlab:app:setup RAILS_ENV=production"

# Setup gitlab hooks
sudo cp /home/gitlab/gitlab/lib/hooks/post-receive /home/git/share/gitolite/hooks/common/post-receive
sudo chown git:git /home/git/share/gitolite/hooks/common/post-receive

# Set the first occurrence of host in the Gitlab config to the publicly available domain name
sudo sed -i '0,/host/s/localhost/'`wget -qO- http://instance-data/latest/meta-data/public-hostname`'/' /home/gitlab/gitlab/config/gitlab.yml

# Tighten security
sudo -u git chmod 750 /home/git/gitolite
sudo -u gitlab chmod 660 /home/gitlab/gitlab/config/*.yml

# Gitlab installation test (optional)
# sudo -u gitlab bundle exec rake gitlab:app:status RAILS_ENV=production
# sudo -u gitlab bundle exec rails s -e production
# sudo -u gitlab bundle exec rake environment resque:work QUEUE=* RAILS_ENV=production BACKGROUND=no

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

## Gitlab service commands (unicorn and resque)
## restart doesn't restart resque, only start/stop effect it.
sudo -u gitlab service gitlab start

# nginx Service commands
sudo service nginx restart

# Go to gitlab directory by default on next login.
echo 'cd /home/gitlab/gitlab' >> /home/ubuntu/.bashrc
