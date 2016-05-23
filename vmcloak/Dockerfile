FROM harryr/cockatoo:virtualbox5
MAINTAINER Harry Roberts <harry.roberts@xiphosresearch.co.uk>

# Example:
# docker run --net=host --privileged -v /dev/vboxdrv:/dev/vboxdrv -v /home/user/OperatingSystems:/mnt/vmcloak/iso -ti 04fe99a285f8 /mnt/vmcloak/makevm.sh derp XP_Pro.iso XXXXX-XXXXX-XXXXX-XXXXX-XXXXX

RUN apt-get -y install mkisofs genisoimage python2.7 python-pip

RUN apt-get clean 

RUN pip install vmcloak

RUN mkdir -p /mnt/vmcloak/data /mnt/vmcloak/vm /mnt/vmcloak/iso
COPY makevm.sh /mnt/vmcloak/makevm.sh

VOLUME /mnt/vmcloak/vm
VOLUME /mnt/vmcloak/data
VOLUME /mnt/vmcloak/iso

CMD ["/mnt/vmcloak/makevm.sh"]