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

While Docker is used to conveniently package software, vmcloak and worker run
in privileged mode within the hosts network namespace, this is presently
required for VirtualBox to fully function.

## Getting Started

Cockatoo is built and run using recent versions of Ubuntu as the host and guest
OS's, it will work with recent versions of Debian, and with some extra effort 
should work on RHEL, Alpine etc. If you still use Slackware, I'm sorry, but you 
have much bigger problems to worry about first.

Installation directory structure:

* `/cockatoo`
	- `src` - Cockatoo repository
	- `isos` - Contains OS ISO images for vmcloak
	- `data` (auto created)
		- `vmcloak` - Persistent vmcloak data (built VMs) (auto-created)
		- `worker-vms` - VM snapshots used by cuckoo worker (auto-created)
		- `worker-storage` - Worker results storage directory (auto-created)
		- `dist-pgdata` - Cuckoo Dist PostgreSQL data (auto-created)

First, setup the `/cockatoo` directory, as `root`, with:

	sudo -i
	mkdir /cockatoo && cd /cockatoo
	git clone https://github.com/HarryR/cockatoo src
	mkdir isos
	cd isos && wget http://torrents.example.com/winxp.iso

Then, still as `root`, install prerequesites (VirtualBox, Docker etc.) and build the
containers with:

	make -C /cockatoo/src prereq build

The full build process will take 10 minutes to an hour+ depending on your
internet, cpu and disk speeds etc. Assuming everything goes well you will have 
everything necessary to build VMS, run Cuckoo and start analysing malware.

So, lets build a Windows XP base image using the ISO you pirated^H^H^H stole 
from your grandma and a serial key you found underneath a friends laptop.

	make -C /cockatoo/src run-vmcloak
	$ /root/makevm.sh winxp32-base winxp winxp.iso B6VT6-VY6DP-VXD7G-...

## Useful Links

 * http://vmcloak.org/
 * https://www.cuckoosandbox.org/
 * http://deaddrop.threatpool.com/vmcloak-how-to/