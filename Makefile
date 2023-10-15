.PHONY: all clean test build run

all clean test build run:
	$(MAKE) $(MAKEFLAGS) -C test $@
