SHELL := /bin/bash
IMAGE := $(notdir $(CURDIR))
THIS_FILE := $(lastword $(MAKEFILE_LIST))

.PHONY: all clean build run config test ssh

all: build run config test

mrproper :
	@echo "Removing Containers and Images"
	bash -c "docker rm $$(docker stop $$(docker ps -a -q --filter ancestor=$(IMAGE) --format={{.ID}})) && \
	         docker rmi $$(docker images --format '{{.Repository}}' | grep $(IMAGE))"

clean :
	@echo "Restarting Container"
	bash -c "docker rm $$(docker stop $(IMAGE))"
	 @$(MAKE) -f $(THIS_FILE) run

build:
	@echo "Building Image"
	bash -c "CWD=$${PWD##*/} rocker build"

run:
	@echo "Running Container"
	bash -c "docker network ls | grep mynetwork || docker network create mynetwork"
	bash -c "docker run --cap-add=SYS_ADMIN -d -e container=docker --network mynetwork --stop-signal SIGRTMIN+3 \
	--name $(IMAGE) \
	--volume /sys/fs/cgroup:/sys/fs/cgroup \
	--volume $(CURDIR)/playbook.yaml:/tmp/playbook.yaml \
	--volume $(CURDIR)/extra_vars.yaml:/tmp/extra_vars.yaml \
	--volume $(CURDIR)/roles:/tmp/roles \
	--volume $(CURDIR)/test:/tmp/test \
	$(IMAGE) /usr/sbin/init"


config:
	@echo "Running Ansible"
	bash -c "docker exec -ti $(IMAGE) ansible-playbook -i inventory --extra-vars=@/tmp/extra_vars.yaml --connection=local --sudo /tmp/playbook.yaml"

test:
	@echo "Running Tests"
	bash -c "docker exec -ti $(IMAGE) inspec exec /tmp/test/inspec"

ssh:
	bash -c "docker exec -ti $(IMAGE) /bin/bash"
