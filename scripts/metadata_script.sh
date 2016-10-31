#! /usr/bin/env bash

error_exit() {
	echo "$1" >> /tmp/userdata.log
	exit 1
}

#selinux
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

#sshd
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/^#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
systemctl reload sshd || error_exit 'Failed to reload sshd service'

#firewalld
systemctl stop firewalld
systemctl disable firewalld

#yum
yum -y install epel-release sysstat ed wget net-tools

#ssh
ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
cat /root/.ssh/id_rsa.pub >>/root/.ssh/authorized_keys
