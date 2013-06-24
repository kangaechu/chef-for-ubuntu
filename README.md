# Chef for Ubuntu

This is a sample chef repository and installation steps document for Ubuntu 12.10.

At this repository you don't use chef-server.
You only use chef-solo and git command in the custom bash script `chef-host`.

# Usage

Following will build your Ubuntu sever environment in a few steps.

1. Modify your host name.

        # sudo vi /etc/hostname

    You need to edit like following.

        www.example.com

1. Reboot system to use modified hostname.

        # sudo reboot

1. Install chef using Omnibus. You only run below command.

        # sudo sh -c "curl -L https://www.opscode.com/chef/install.sh | bash"

    note) Omunibus is a installer of chef packaging. If you want to get more infomations, see `http://www.opscode.com/blog/2012/06/29/omnibus-chef-packaging/`.

1. Install git

        # sudo apt-get -y install git

1. Clone this git repository

        # sudo git clone https://github.com/kangaechu/chef-for-ubuntu.git /var/chef

1. Run chef-solo using following command

        # sudo sh -c /var/chef/bin/chef-host

    You will get environments of Apache(httpd), MySQL, Redmine, GitLab, WordPress.


