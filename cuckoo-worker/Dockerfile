FROM harryr/cockatoo:cuckoo

ENV DEBIAN_FRONTEND noninteractive
ENV PIP_NO_CACHE_DIR off
ENV PIP_DISABLE_PIP_VERSION_CHECK on

COPY conf/reporting.conf /cuckoo/conf/reporting.conf
COPY conf/cuckoo.conf /cuckoo/conf/cuckoo.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]

# RUN apt-get install uwsgi uwsgi-plugin-python nginx

