#!/bin/bash

setup_node() {
    echo setup username $1 in node $2

    #nopassword sudo
    sudo scp /etc/sudoers.d/$1 root@$2:/etc/sudoers.d/
    sudo scp /etc/hosts root@$2:/etc/

    #set hostname
    ssh $2 sudo hostnamectl set-hostname $2
    ssh $2 hostname

    # nopassword ssh
    ssh-copy-id $1@$2

    #selinux disable
    ssh $2 sudo setenforce 0
}


# run as user: liteon

# nopassword sudo
echo "liteon ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/liteon
sudo chmod 0440 /etc/sudoers.d/liteon

# nopassword ssh
ssh-copy-id liteon@admin
sudo hostnamectl set-hostname admin
hostname

#selinux disable
sudo setenforce 0

# set host name and dns for all nodes
sudo bash -c "echo '10.24.48.31 admin' >> /etc/hosts"
sudo bash -c "echo '10.24.48.33 mon0' >> /etc/hosts"
sudo bash -c "echo '10.24.48.34 osd0' >> /etc/hosts"
sudo bash -c "echo '10.24.48.35 osd1' >> /etc/hosts"
sudo bash -c "echo '10.24.48.36 osd2' >> /etc/hosts"

# copy setup to every node
setup_node liteon mon0
setup_node liteon osd0
setup_node liteon osd1
setup_node liteon osd2
