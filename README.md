OpenConnect VM
==============

Simple Vagrant configuration for a local OpenConnect-ready VM that can serve as a web traffic proxy.

Configuration
-------------

Create a `config.yml` file in the `/vars` directory with your server address, username, and password. Use `/vars/config.yml.sample` as an example for how this should be set up.

Next, run `vagrant up` to build and configure the VM.

Proxy
-----------

The server will be automatically set up to act as both a SOCKS5 and an HTTP proxy - you can route all web, SSH, and other traffic through the server to the configured VPN.

The SOCKS proxy is listening on port `1080`.

The HTTP proxy is listening on port `2080`.

Under VirtualBox, the server will automatically start with a local IP of `192.168.90.10` (use this when configuring proxied applications).

Under Hyper-V, you will need to identify the dynamically-provisioned IP address after boot, but can likely use the `openconnect` host alias during configuration.

OpenVPN Client
--------------

The VM supports OpenVPN servers as an alternative option to AnyConnect. To switch to connecting to an OpenVPN server, you need to do the following:

- Create a `config` directory in this repository (it will be ignored by git)
- Move your .ovpn configuration file into that directory as well as any related files (keys, certs, etc.).
- Modify the `ovpn` settings in `vars/config.yml`:
  - Set `ovpn.directory` to the directory your configuration file is in, *relative to the repository root*. Omit leading and trailing slashes. This is the directory from which the `openvpn` client command will be run (using the `--cd` command line flag), so make sure all resources referenced in your .ovpn file are relative to this directory.
  - Set `ovpn.configuration` to the name of the configuration file, relative to `ovpn.directory`.
- Create a `Customfile` in the root of this repository if one doesn't already exist
- Add `vpn_server = "openvpn"` to your Customfile
- Run `vagrant destroy` if you already have an existing machine.
- Run `vagrant up`.

Assuming your ovpn config file is correct, you will now be able to use the SOCKS and HTTP proxies as outlined above and below.

### Browser Configuration

Various browsers work a bit differently with SOCKS proxies.

#### Firefox

Firefox is relatively straight-forward. In the Advanced section of the settings screen, you can configure network settings. Add a SOCKS5 proxy pointing to `openconnect` on port `1080`. Don't forget to add `openconnect` itself to the "no proxy" list or Firefox will try to grab the DNS entries for your proxy server from the proxy itself and end up in an infinite loop!

![Firefox configuration](https://s3.amazonaws.com/uploads.hipchat.com/52421/365110/YbBNENfUGjXl60L/upload.png)

#### Safari

Thankfully, Safari's proxy configuration is somewhat similar to Firefox's. Just set the proxy settings in the network configuration.

#### Chrome

Chrome can be a bit tricky; particularly on Windows where it uses _system-level_ proxy configuration by default. Instead of editing network configuration within the application, you must launch Chrome with a set of command-line flags that will then start it up using the proxy instead of the defaults.

On Mac OS you can add the following script to your `~/.bash_profile` to launch or relaunch Chrome automatically:

```sh
proxyChrome() {
	local proxy=("open" "-a" "\"Google Chrome\"" "--args");
	if [ "$1" = "proxyon" ]
		then
		proxy+=("--proxy-server=\"socks5://openconnect\"")
		proxy+=("--proxy-bypass-list=\"openconnect;*.google.com;*twitter.com;*facebook.com;localhost;127.0.0.1\"")
	elif [ "$1" = "proxyoff" ]
		then
		proxy+=("--no-proxy-server")
	fi

	if [ ! -z "{$proxy[@]}" ]
		then
		if pgrep "Google Chrome" > /dev/null
			then
			killall "Google Chrome"
			proxy+=("--restore-last-session")
			sleep 1
		fi
		eval "${proxy[@]}"
	fi
}
```

A similar script could likely be achieved on any bash-style system, but the `open` command is only available in Mac OS.

### Shell Configuration

If you need to use Git or other shell-based tools over the SOCKS proxy, you can configure SSH to use SOCKS through its 
 configuration file (`~/.ssh/config`).
 
#### *Nix

On a Mac or Linux installation, we can use netcat to pass data through to the VPN.

```sh
Host {{ VPN-protected server }}
	ProxyCommand nc -X 5 -x openconnect:1080 %h %p
```

#### Windows

Windows obviously doesn't have the same tools as Linux systems. However, if you installed Git from [the standard packages](https://git-scm.com/downloads) and added Git and its tools to the system path, you have access to [some alternative tools](http://ttmm.io/tech/linux-flavored-windows/) that will provide the same functionality:

```sh
Host {{ VPN-protected server }}
	ProxyCommand connect -S openconnect:1080 %h %p
```	

### Other Tools

Some other command-line tools (like NPM and Composer) will thankfully respect the `HTTP_PROXY` environment variables. If you need to use these tools over the proxy, be sure to set the environment variable as necessary.

#### *Nix

Export the `HTTP_PROXY` and `HTTPS_PROXY` environment variables on the active terminal:

```sh
$ export HTTP_PROXY=http://openconnect:2080
$ export HTTPS_PROXY=http://openconnect:2080
```

#### Windows

Windows exports environment variables slightly differently, using `SET` instead of `export`:

```sh
> SET HTTP_PROXY=http://openconnect:2080
> SET HTTPS_PROXY=http://openconnect:2080
```

### Utilities

For convenience, those of you using a Bash-type shell can add a script to your bash profile for remotely turning the SOCKS proxy on and off from anywhere on your system:

```sh
cntrlVPN() {
	local current=$PWD
	cd {{ location where you cloned openconnect-vm }}
	vagrant $1
	cd $current
}
alias vpn=cntrlVPN
```

Now, you can type `vpn up` and `vpn halt` from any location in a terminal to activate/deactivate the SOCKS proxy at will.

If you're also using the Chrome proxy script above, you can add the following between the `vagrant $1` and `cd $current` lines to automatically restart Chrome with or without proxy support when you bring the proxy up and down:

```sh
if [ "$1" = "up" ] || [ "$1" = "reload" ]
	then
	proxyChrome proxyon
elif [ "$1" = "halt" ] || [ "$1" = "suspend" ] || [ "$1" = "destroy" ]
	then
	proxyChrome proxyoff
fi
```

Frequently Asked Questions
--------------------------

### My password was changed for the VPN, how do I let the VM know?

Just update the values in `/vars/config.yml` and run `vagrant provision`. This will both update machine and reset any configuration values necessary.

Credits
-------

The Ansible provisioning [was originally built by Crown Copyright (Government Digital Service)](https://github.com/alphagov/ansible-role-openconnect)

Special thanks to [Luke Woodward](https://github.com/lkwdwrd) for testing support and Bash alias/functions!
