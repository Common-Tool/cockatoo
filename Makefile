ROOT_DIR = $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DATA_DIR = $(ROOT_DIR)/../data/

VMCLOAK_ISOS_DIR=$(ROOT_DIR)/../isos
VMCLOAK_PERSIST_DIR=$(DATA_DIR)/vmcloak
WORKER_STORAGE_DIR=$(DATA_DIR)/worker-storage
WORKER_VMS_DIR=$(DATA_DIR)/worker-vms
PGDATA_WORKER_DIR=$(DATA_DIR)/worker-pgdata
PGDATA_DIST_DIR=$(DATA_DIR)/dist-pgdata
DOCKER_BASETAG=harryr/cockatoo

all: postgresql cuckoo-worker
	@echo "Ok, now you can be deploying the softwares, much wow."

conf:
	mkdir $@
	echo '*' > $@/.gitignore

# Generate a postgresql database password automagically
conf/pgpass: conf
	openssl rand -base64 15 | tr -cd '[:alnum:]\n' > $@

$(DATA_DIR):
	mkdir -p $@

$(VMCLOAK_ISOS_DIR):
	mkdir -p $@

$(WORKER_STORAGE_DIR): $(DATA_DIR)
	mkdir -p $@

$(VMCLOAK_PERSIST_DIR): $(DATA_DIR)
	mkdir -p $@

$(WORKER_VMS_DIR): $(DATA_DIR)
	mkdir -p $@

$(PGDATA_WORKER_DIR): $(DATA_DIR)
	mkdir -p $@

$(PGDATA_DIST_DIR): $(DATA_DIR)
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

.PHONY: cuckoo-dist
cuckoo-dist: cuckoo
	cd $@ && docker build -t $(DOCKER_BASETAG):$@ .

.PHONY: prereq-docker
prereq-docker:
	apt-get update
	apt-get -y install apt-transport-https ca-certificates
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list
	apt-get update
	apt-get -y install linux-image-extra-`uname -r` docker-engine docker-compose

.PHONY: prereq-virtualbox
prereq-virtualbox:
	apt-get -y install virtualbox-dkms

.PHONY: prereq
prereq:	prereq-virtualbox prereq-docker

.PHONY: build
build: virtualbox5 cuckoo cuckoo-worker cuckoo-dist postgresql


# Start a shell in the vmcloak container
run-vmcloak: vmcloak  $(VMCLOAK_PERSIST_DIR)
	docker run -h vmcloak --net=host --privileged -v $(VMCLOAK_PERSIST_DIR):/root/.vmcloak/ -v /dev/vboxdrv:/dev/vboxdrv -v $(VMCLOAK_ISOS_DIR):/mnt/isos -ti harryr/cockatoo:vmcloak bash

run-cuckoo-worker: cuckoo-worker conf/pgpass $(WORKER_STORAGE_DIR) $(WORKER_VMS_DIR)
	# -e CUCKOO_DB_DSN=postgresql+psycopg2://postgres:`cat $(ROOT_DIR)/conf/pgpass`@172.17.0.3/postgres
	# Note: privileged is required for virtualbox to work correctly
	# Note: net=host is required to access vboxnet0 from inside the container
	# Note: cap-add net_admin is necessary for tcpdump to work
	docker run --net=host --privileged --cap-add net_admin -v $(WORKER_STORAGE_DIR):/cuckoo/storage/ -v $(VMCLOAK_PERSIST_DIR):/root/.vmcloak/ -v $(WORKER_VMS_DIR):/root/.vmcloak/vms/ -v /dev/vboxdrv:/dev/vboxdrv -e CUCKOO_DB_DSN= -ti harryr/cockatoo:cuckoo-worker bash

run-cuckoo-dist: cuckoo-dist conf/pgpass
	# -e CUCKOO_DB_DSN=postgresql+psycopg2://postgres:`cat $(ROOT_DIR)/conf/pgpass`@172.17.0.3/postgres
	docker run -v $(VMCLOAK_PERSIST_DIR):/root/.vmcloak/ -e CUCKOO_DB_DSN= -ti harryr/cockatoo:cuckoo-dist

# Start the Cuckoo Worker PostgreSQL container
#run-cuckoo-worker-db: postgresql $(PGDATA_WORKER_DIR) conf/pgpass
#	docker run -v $(PGDATA_WORKER_DIR):/var/lib/postgresql/data/ -e POSTGRES_PASSWORD=`cat $(ROOT_DIR)/conf/pgpass` -ti harryr/cockatoo:postgresql

# Start the Cuckoo Dist Server PostgreSQL container
run-cuckoo-dist-db: postgresql $(PGDATA_DIST_DIR) conf/pgpass
	docker run -v $(PGDATA_DIST_DIR):/var/lib/postgresql/data/ -e POSTGRES_PASSWORD=`cat $(ROOT_DIR)/conf/pgpass` -ti harryr/cockatoo:postgresql