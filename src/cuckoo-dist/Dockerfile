FROM harryr/cockatoo:cuckoo

COPY settings.py /cuckoo/distributed/settings.py

EXPOSE 9003

CMD ["/usr/bin/python", "/cuckoo/distributed/app.py", "0.0.0.0", "9003"]