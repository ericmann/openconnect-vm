OpenConnect VM
==============

Simple Vagrant configuration for a local OpenConnect-ready VM that can serve as a web traffic proxy.

Configuration
-------------

Create a `config.yml` file in the `/vars` directory with your server address, username, and password. Use `/vars/config.yml.sample` as an example for how this should be set up.

Next, run `vagrant up` to build and configure the VM.

SOCKS Proxy
-----------

Frequently Asked Questions
--------------------------

### How do I change my VPN username?

Just update the values in `/vars/config.yml` and re-run `vagrant up`. This will both update machine and reset any configuration values necessary.

Credits
-------

The Ansible provisioning [was originally built by Crown Copyright (Government Digital Service)](https://github.com/alphagov/ansible-role-openconnect)