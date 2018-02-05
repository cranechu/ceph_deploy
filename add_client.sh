#!/bin/bash

setup_node() {
    echo setup username $1 in node $2

    #copy host file
    sudo scp /etc/hosts root@$2:/etc/

    #nopassword sudo
    sudo scp /etc/sudoers.d/$1 root@$2:/etc/sudoers.d/
    ssh $2 sudo chmod 0440 /etc/sudoers.d/$1
    ssh $2 sudo "sed -i 's/Defaults requiretty/#Defaults requiretty/g' /etc/sudoers"

    #set hostname
    ssh $2 sudo hostnamectl set-hostname $2
    ssh $2 hostname

    #update system
    ssh $2 sudo yum update -y

    # nopassword ssh
    ssh-copy-id -f $1@$2

    #selinux disable
    ssh $2 sudo setenforce 0

    #enable NTP
    ssh $2 sudo yum install -y ntp ntpdate ntp-doc
    ssh $2 sudo ntpdate 0.us.pool.ntp.org
    ssh $2 sudo hwclock --systohc
    ssh $2 sudo systemctl enable ntpd.service
    ssh $2 sudo systemctl start ntpd.service

    #disable selinux
    ssh $2 sudo "sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config"
    ssh $2 sudo setenforce 0

    #setup firewalled
    ssh $2 sudo systemctl start firewalld
    ssh $2 sudo systemctl enable firewalld
    ssh $2 sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
    ssh $2 sudo firewall-cmd --zone=public --add-port=2003/tcp --permanent
    ssh $2 sudo firewall-cmd --zone=public --add-port=4505-4506/tcp --permanent
    ssh $2 sudo firewall-cmd --zone=public --add-port=6789/tcp --permanent
    ssh $2 sudo firewall-cmd --zone=public --add-port=6800-7300/tcp --permanent
    ssh $2 sudo firewall-cmd --reload

    #clear yum cache
    ssh $2 sudo rm -rf /var/cache/yum
}


# set host name and dns for all nodes
sudo bash -c "echo '10.24.48.12 mibook' >> /etc/hosts"

# copy setup to every node
setup_node liteon mibook

ceph-deploy install --release luminous mibook

#copy ceph conf/key to all nodes
ceph-deploy mibook
