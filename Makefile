.PHONY: clean test

test: clean
	@cd test && docker-compose build && docker-compose run test || docker-compose logs passenger

clean:
	@cd test && docker-compose down