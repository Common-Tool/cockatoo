ROOT_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
VMCLOAK_PERSIST_DIR=$(ROOT_DIR)/../vmcloak-persistent
VMCLOAK_ISOS_DIR=$(ROOT_DIR)/../vmcloak-isos
PGDATA_DIR=$(ROOT_DIR)/../cuckoo-pgdata
DOCKER_BASETAG=harryr/cockatoo

all: postgresql cuckoo-worker
	@echo "Ok, now it can be deployed"

conf:
	mkdir $@

# Generate a postgresql database password automagically
conf/pgpass: conf
	openssl rand -base64 15 | tr -cd '[:alnum:]\n' > $@

$(VMCLOAK_PERSIST_DIR):
	mkdir -p $@

$(PGDATA_DIR):
	mkdir -p $@

.PHONY: vmcloak
vmcloak:
	cd $@ && docker build -t $(DOCKER_BASETAG):$@ .

.PHONY: virtualbox5
virtualbox5:
	cd $@ && docker build -t $(DOCKER_BASETAG):$@ .

.PHONY: cuckoo
cuckoo: virtualbox5
	cd $@ && docker build -t $(DOCKER_BASETAG):$@ .

.PHONY: postgresql
postgresql:
	cd $@ && docker build -t $(DOCKER_BASETAG):$@ .

.PHONY: cuckoo-worker
cuckoo-worker: cuckoo
	cd $@ && docker build -t $(DOCKER_BASETAG):$@ .


# Start a shell in the vmcloak container
vmcloak-run: vmcloak  $(VMCLOAK_PERSIST_DIR)
	docker run --net=host --privileged -v $(VMCLOAK_PERSIST_DIR):/root/.vmcloak/ -v /dev/vboxdrv:/dev/vboxdrv -v $(VMCLOAK_ISOS_DIR):/mnt/isos -ti harryr/cockatoo:vmcloak bash

cuckoo-worker-run: cuckoo-worker conf/pgpass
	docker run -e CUCKOO_DB_DSN=postgresql+psycopg2://postgres:`cat $(ROOT_DIR)/conf/pgpass`@172.17.0.3/postgres -ti harryr/cockatoo:cuckoo-worker

# Start the Cuckoo Worker PostgreSQL container
cuckoo-worker-pgdb-run: postgresql $(PGDATA_DIR) conf/pgpass
	docker run -v $(PGDATA_DIR):/var/lib/postgresql/data/ -e POSTGRES_PASSWORD=`cat $(ROOT_DIR)/conf/pgpass` -ti harryr/cockatoo:postgresql