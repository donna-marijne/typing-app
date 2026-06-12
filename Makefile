.PHONY: docker gen build migrate run dev
.DEFAULT_GOAL := build

docker:
	docker compose up --detach

gen: docker
	$(MAKE) -C database gen

build: gen
	$(MAKE) -C api build

migrate: docker
	$(MAKE) -C database migrate-up

run: docker
	$(MAKE) -C api run

dev: build migrate run
