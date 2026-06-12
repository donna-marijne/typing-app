.PHONY: gen migrate-up migrate-down

gen:
	sqlc generate

migrate-up:
	goose up -dir ./schema -env ../.env

migrate-down:
	goose down -dir ./schema -env ../.env
