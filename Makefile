##
## Copyright (C) 2017 Thomas Gerbet
##
## This software may be modified and distributed under the terms
## of the MIT license.  See the LICENSE file for details.


CC ?= gcc
LD ?= gcc
CC_DEP ?= $(CC)

ifeq ($(shell uname),Darwin)
LIBTOOL ?= glibtool
else
LIBTOOL ?= libtool
endif

CFLAGS=-O2 -Wall -Werror -Wextra -pedantic -std=c90 -Ilib
LDFLAGS=

LT_CC:=$(LIBTOOL) --tag=CC --mode=compile $(CC)
LT_LD:=$(LIBTOOL) --tag=CC --mode=link $(CC)

ifneq (, $(shell which $(LIBTOOL) 2>/dev/null ))
CC:=$(LT_CC)
CC_DEP:=$(LT_CC_DEP)
LD:=$(LT_LD)
LDLIB:=$(LT_LD)
LIB_EXT:=la
else
LIB_EXT:=a
LD:=$(CC)
endif

CFLAGS+=$(TARGETCFLAGS)
LDFLAGS+=$(TARGETLDFLAGS)

sha1collisiondetector: sha1collisiondetector.o sha1collisiondetection/bin/libsha1detectcoll.$(LIB_EXT)
	$(LD) $(LDFLAGS) sha1collisiondetector.o -Lsha1collisiondetection/bin -lsha1detectcoll -o $(@)

sha1collisiondetection/bin/libsha1detectcoll.$(LIB_EXT):
	$(MAKE) -C sha1collisiondetection bin/libsha1detectcoll.$(LIB_EXT)

sha1collisiondetector.o: main.c
	$(CC) $(CFLAGS) -o $@ -c $<

.PHONY: clean
clean:
	$(MAKE) -C sha1collisiondetection clean
	-rm sha1collisiondetector*

.PHONY: test
test: sha1collisiondetector
	./sha1collisiondetector tests/shattered-1.pdf; test $$? = 3
	./sha1collisiondetector tests/shattered-2.pdf; test $$? = 3
	cat tests/shattered-1.pdf | ./sha1collisiondetector; test $$? = 3
	./sha1collisiondetector tests/non-shattered.pdf; test $$? = 0
	cat tests/non-shattered.pdf | ./sha1collisiondetector; test $$? = 0
	./sha1collisiondetector tests/does-not-exist.pdf; test $$? = 1
