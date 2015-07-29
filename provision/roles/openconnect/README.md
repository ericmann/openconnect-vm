Openconnect
=========

A simple ansible role for installing and configuring Cisco OpenConnect client. 

Requirements
------------

Works only on Ubuntu. Requires definition of variables (see below). 

Role Variables
--------------
`vpn_url` A full URL to the VPN server.

`vpn_user` Username for the VPN connection.

`vpn_password` Password for the VPN connection.

Dependencies
------------

* none

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: my-box
      roles:
         - { role: openconnect, vpn_url: "https://vpn.myserver.com/abc", vpn_user: "user", vpn_password: "pass" }


License
-------

see LICENSE

