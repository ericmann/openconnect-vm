# -*- mode: ruby -*-
# vi: set ft=ruby :

dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))
vagrant_name = File.basename(dir)

Vagrant.configure("2") do |config|

  # Store the current version of Vagrant for use in conditionals when dealing
  # with possible backward compatible issues.
  vagrant_version = Vagrant::VERSION.sub(/^v/, '')

  # Custom details for Virtualbox if using it as a provider
  config.vm.provider :virtualbox do |v, override|
    v.customize ["modifyvm", :id, "--memory", 512]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    # VM Name
    v.name = vagrant_name

    # Default Box IP Address
    #
    # This is the IP address that your host will communicate to the guest through. In the
    # case of the default `192.168.70.10` that we've provided, VirtualBox will setup another
    # network adapter on your host machine with the IP `192.168.90.1` as a gateway.
    #
    # If you are already on a network using the 192.168.90.x subnet, this should be changed.
    # If you are running more than one VM through VirtualBox, different subnets should be used
    # for those as well. This includes other Vagrant boxes.
    override.vm.network :private_network, ip: "192.168.90.10"
  end

  # Custom details for Hyper-V if using it as a provider
  config.vm.provider :hyperv do |v, override|
    v.memory = 512

	# VM Name
    v.vmname = vagrant_name

    # Networking
    #
    # Hyper-V uses DHCP to assign IP addresses, but if we don't configure the network to be "private",
    # then we can't interact with it programmatically.
    override.vm.network :private_network
  end

  # Default Ubuntu Box
  config.vm.box = "ericmann/trusty64"

  # Default Hostname
  config.vm.hostname = "amcns"

  # Forward Agent
  #
  # Enable agent forwarding on vagrant ssh commands. This allows you to use ssh keys
  # on your host machine inside the guest. See the manual for `ssh-add`.
  config.ssh.forward_agent = true

  # To avoid stdin/tty issues
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  # Ansible Provisioning
  #
  # Actually, we're using shell provisioning to proxy to Ansible so things work reliably across operating systems.
  config.vm.provision :shell do |s|
    s.path = "bin/provision.sh"
  end
end