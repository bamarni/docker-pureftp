NS = bamarni
REPO = pureftp
VERSION ?= latest
PWD ?= $(shell pwd)
IP ?= $(shell docker-machine ip dev)

.PHONY: build run push

build:
	docker build -t $(NS)/$(REPO):$(VERSION) .

run:
	mkdir -p test

	docker run -t --privileged --rm --name ftp\
		-e PUREFTP_PASSIVE_IP=$(IP)\
		-p 21:21 -p 40000-40009:40000-40009\
		-v $(PWD)/test:/home/ftpuser/user -e PUREFTP_USER_PASSWORD=pass\
		$(NS)/$(REPO):$(VERSION)

push:
	docker push $(NS)/$(REPO):$(VERSION)

default: build
