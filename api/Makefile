HONY: build deploy start

build:
	sam build

deploy: build
	sam deploy

run: build
	sam local start-api
