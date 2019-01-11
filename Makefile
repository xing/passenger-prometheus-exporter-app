.PHONY: clean test

test: clean
	@cd test && docker-compose build && docker-compose run test

clean:
	@cd test && docker-compose down || true
