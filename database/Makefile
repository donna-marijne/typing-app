.PHONY: all migrate-up migrate-down

all:
	sqlc generate

migrate-up:
	goose up -dir ./schema -env ../.env

migrate-down:
	goose down -dir ./schema -env ../.env
