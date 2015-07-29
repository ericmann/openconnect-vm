OpenConnect VM
==============

Simple Vagrant configuration for a local OpenConnect-ready VM that can serve as a web traffic proxy.

Configuration
-------------

Create a `config.yml` file in the `/vars` directory with your server address, username, and password. Use `/vars/config.yml.sample` as an example for how this should be set up.

Next, run `vagrant up` to build and configure the VM.

SOCKS Proxy
-----------

The server will be automatically set up to act as a SOCKS5 proxy - you can route all web, SSH, and other traffic through the server to the configured VPN.

The proxy is listening on port `1080`.

Under VirtualBox, the server will automatically start with a local IP of `192.168.90.10` (use this when configuring proxied applications).

Under Hyper-V, you will need to identify the dynamically-provisioned IP address after boot, but can likely use the `openconnect` host alias during configuration.

Frequently Asked Questions
--------------------------

### How do I change my VPN username?

Just update the values in `/vars/config.yml` and re-run `vagrant up`. This will both update machine and reset any configuration values necessary.

Credits
-------

The Ansible provisioning [was originally built by Crown Copyright (Government Digital Service)](https://github.com/alphagov/ansible-role-openconnect)