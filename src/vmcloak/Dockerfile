FROM harryr/cockatoo:virtualbox5
MAINTAINER Harry Roberts <harry.roberts@xiphosresearch.co.uk>

# Example:
# docker run --net=host --privileged -v /dev/vboxdrv:/dev/vboxdrv -v /home/user/OperatingSystems:/mnt/vmcloak/iso -ti harryr/cockatoo:vmcloak /root/makevm.sh derp winxp XP_Pro.iso XXXXX-XXXXX-XXXXX-XXXXX-XXXXX

RUN apt-get -y install mkisofs genisoimage python2.7 python-pip dmidecode lshw sudo

RUN apt-get clean 

RUN pip install vmcloak

RUN mkdir -p /mnt/isos/ /root/.vmcloak/
COPY makevm.sh /root/makevm.sh

VOLUME /root/.vmcloak/
VOLUME /mnt/isos

CMD ["/root/makevm.sh"]