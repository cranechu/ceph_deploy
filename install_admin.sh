#install emacs and update all software
sudo yum install emacs-nox
sudo yum install wget
sudo yum update

#install ELEP and ceph repository
#TODO: check availibility of EPEL
#TODO: auto yes in yum 
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo cp ./repo_ceph.repo /etc/yum.repos.d/ceph.repo
sudo yum update
sudo yum install ceph-deploy

#check NTP
sudo timedatectl

#generate key for nopassword ssh
ssh-keygen
