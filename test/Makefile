.PHONY: clean test build run
.PHONY: passenger_with_app passenger_without_app passenger_with_visible_prometheus

all: clean build test

build: passenger_with_app passenger_without_app passenger_with_visible_prometheus

passenger_with_app passenger_without_app passenger_with_visible_prometheus:
	docker compose build $@

test:
	docker compose run test

clean:
	docker compose down || true

run:
	docker compose up passenger_with_app passenger_without_app passenger_with_visible_prometheus
