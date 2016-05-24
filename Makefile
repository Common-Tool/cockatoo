BASETAG=harryr/cockatoo

all:
	@echo "Please be choosing what you are need to build. kthx"

.PHONY: vmcloak virtualbox5 cuckoo

vmcloak:
	cd $@ && docker build -t $(BASETAG):$@ .

virtualbox5:
	cd $@ && docker build -t $(BASETAG):$@ .

cuckoo:
	cd $@ && docker build -t $(BASETAG):$@ .
