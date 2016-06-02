FROM harryr/cockatoo:cuckoo

ENV DEBIAN_FRONTEND noninteractive
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on

COPY conf/reporting.conf /cuckoo/conf/reporting.conf
COPY conf/cuckoo.conf /cuckoo/conf/cuckoo.conf
COPY conf/virtualbox.conf /cuckoo/conf/virtualbox.conf
COPY conf/auxiliary.conf /cuckoo/conf/auxiliary.conf
COPY conf/vpn.conf /cuckoo/conf/vpn.conf

COPY supervisord.conf /etc/supervisor/conf.d/cuckoo.conf

COPY docker-entrypoint.sh /
COPY cuckoo-api-wrapper.sh /

# Necessary to avoid weird apparmor problems
# apparmor="DENIED" operation="open" info="Failed name lookup - disconnected path" error=-13 profile="/usr/sbin/tcpdump"
RUN cp /usr/sbin/tcpdump /cuckoo/tcpdump

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8090
EXPOSE 2042

CMD ["/usr/bin/supervisord"]