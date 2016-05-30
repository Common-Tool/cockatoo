Must run VirtualBox first to bring up vboxnet0

http://deaddrop.threatpool.com/vmcloak-how-to/

ISO_DIR=/home/harryr/OperatingSystems

docker run --net=host --privileged -v /home/harryr/Projects/Cockatoo/vmcloak-persistent:/root/.vmcloak/ -v /dev/vboxdrv:/dev/vboxdrv -v /home/harryr/OperatingSystems:/mnt/isos -ti harryr/cockatoo:vmcloak /root/makevm.sh winxp32-base winxp XP_Pro.iso B6VT6-VY6DP-VXD7G-JW77Q-7FY9G 101