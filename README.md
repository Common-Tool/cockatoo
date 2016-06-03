	   _____           _         _              
	  / ____|         | |       | |                   )/_
	 | |     ___   ___| | ____ _| |_ ___   ___       <' \
	 | |    / _ \ / __| |/ / _` | __/ _ \ / _ \      /)  )
	 | |___| (_) | (__|   < (_| | || (_) | (_) |  ---/'-""---
	  \_____\___/ \___|_|\_\__,_|\__\___/ \___/ 
	                                            

## Warning: work in progress, stuff may still be broken.

This Docker-ized distribution of Cuckoo, called Cockatoo, contains everything 
you need to start analyzing malware with Cuckoo using a cluster of workers.
Cuckoo is a relatively complex piece of software requiring many tightly
integrated components, so while Cockatoo should get you 90% of the way there, 
a thorough understanding of virtualisation, networking, Docker, Linux, Cuckoo, 
and generally configuring stuff is highly advantageous to get anywhere quickly.

While Docker is used to conveniently package software, vmcloak and the Cuckoo
worker run in privileged mode within the hosts network namespace, this is
presently required for VirtualBox to fully function.

## Getting Started

The setup process goes as follows:

 1. Checkout cockatoo source code
 2. Install prerequesites
 3. Build Docker containers
 4. Copy Windows ISOs into `cockatoo/isos`
 5. Build and customise Base VMs using `vmcloak`
 6. Start docker containers

Checkout the source, install the prerequesites and build the containers with:

	git clone https://github.com/HarryR/cockatoo
	make -C cockatoo prereq build

The full build process will take 10 minutes to an hour+ depending on your
internet, cpu and disk speeds etc. Assuming everything goes well you will have 
everything necessary to build VMS, run Cuckoo and start analysing malware.

Next, lets build a Windows XP base image using the ISO you stole from your
grandma and a serial key found underneath a laptop in a second-hand PC shop ;)

	wget -O isos/winxp.iso http://torrents.example.com/winxp.iso
	make run-vmcloak
	$ /root/makevm.sh winxp32-base winxp winxp.iso XXXXX-XXXXX-XXXXX-...

The `makevm.sh` script is a quick utility to make building base images easier,
its arguments are:

 * vm-name
 * os-version - one of: `winxp`, `win7`, `win7x64`
 * iso-filename - relative to `isos/`
 * serial-key

When the `cuckoo-worker` container is started it will create a snapshot of all 
the VMs you've created with `vmcloak` and register them with Cuckoo. This 
happens every time the container is started as the worker container keeps 
no persistent data, if you have a lot of VMs it may take a while for Cuckoo 
to be ready to start processing malware.

Finally, it's time to start up the behemoth:

	make run

## Architecture & Infrastructure

IP addresses:

 * `vboxnet0` - `172.28.128.1/24`
 * Cuckoo guest VMs - `172.28.128.100+`

Ports:

 * 9003 - Cuckoo Distributed API
 * 2042 - Cuckoo Worker Reporting Server
 * 8090 - Cuckoo Worker API

## TODO / Maybe / Ideas etc.

 * Speed up startup of cuckoo worker (specifically the VM import!)
 * More reliable start/stop mechanism
 * Replace supervisor with something that manages dependencies + delays
 * Better logging management, hierarchical?
 * Tighter security + protection
 * All roads point to `systemd` ....

## Useful Links

 * http://vmcloak.org/
 * https://www.cuckoosandbox.org/
 * http://deaddrop.threatpool.com/vmcloak-how-to/

## Using the VPN



	make cryptostorm
	systemctl daemon-reload
