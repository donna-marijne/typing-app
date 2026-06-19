.PHONY: all clean deploy docker migrate run
.DEFAULT_GOAL := all

docker:
	docker compose up --detach

all: docker
	$(MAKE) -C database all
	$(MAKE) -C api all
	$(MAKE) -C infra all

clean:
	$(MAKE) -C api clean

deploy: all
	$(MAKE) -C infra deploy

migrate: docker
	$(MAKE) -C database migrate-up

run: docker
	$(MAKE) -C api run

# dev: build migrate run
