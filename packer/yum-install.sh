#!/bin/bash -ex

#echo "http_proxy=http://nonprod-proxy.csg.iagcloud.net:8080" | sudo tee -a /etc/environment
#echo "https_proxy=http://nonprod-proxy.csg.iagcloud.net:8080" | sudo tee -a /etc/environment

#export http_proxy=http://nonprod-proxy.csg.iagcloud.net:8080
#export https_proxy=http://nonprod-proxy.csg.iagcloud.net:8080
#sudo yum check-update -y
sudo yum makecache -y
sudo yum install lvm2 -y  
#sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
#sudo yum install ansible -y