#!/bin/bash
cat << "ARTWORK"
ARTWORK

echo
echo "Updating APT sources."
echo
apt-get update > /dev/null
echo
echo "Installing Ansible."
echo
apt-get -y install software-properties-common
add-apt-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible
ansible_version=`dpkg -s ansible 2>&1 | grep Version | cut -f2 -d' '`
echo
echo "Installed Ansible $ansible_version"

ANS_BIN=`which ansible-playbook`

if [[ -z $ANS_BIN ]]
    then
    echo "Error: Cannot locate Ansible. Aborting."
    echo
    exit
fi

echo
echo "Validating Ansible hostfile permissions."
echo
chmod 644 /vagrant/provision/hosts

# More continuous scroll of the Ansible standard output buffer
export PYTHONUNBUFFERED=1

# $ANS_BIN /vagrant/provision/playbook.yml -i /vagrant/provision/hosts
$ANS_BIN /vagrant/provision/playbook.yml -i'127.0.0.1,'