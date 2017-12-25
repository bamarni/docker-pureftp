NS = bamarni
REPO = pureftp
VERSION ?= latest
PUREFTP_VERSION ?= 1.0.46
PWD ?= $(shell pwd)
IP ?= $(shell docker-machine ip dev)

.PHONY: build run push

build:
	docker build --build-arg PUREFTP_VERSION=$(PUREFTP_VERSION) -t $(NS)/$(REPO):$(VERSION) .

run:
	mkdir -p test

	docker run -it --rm --name ftp \
		-e PUREFTP_PASSIVE_IP=$(IP) \
		-p 21:21 -p 40000-40009:40000-40009 \
		--volumes-from syslog \
		-v $(PWD)/entrypoint.sh:/entrypoint.sh \
		-v $(PWD)/test:/home/ftpuser/user -e PUREFTP_USER_PASSWORD=pass \
		$(NS)/$(REPO):$(VERSION)

bash:
	docker run -it --rm $(NS)/$(REPO):$(VERSION) bash

push:
	docker push $(NS)/$(REPO):$(VERSION)

default: build
