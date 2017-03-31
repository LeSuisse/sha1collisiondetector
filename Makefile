##
## Copyright (C) 2017 Thomas Gerbet
##
## This software may be modified and distributed under the terms
## of the MIT license.  See the LICENSE file for details.


CC ?= gcc

CFLAGS=-O2 -Wall -Werror -Wextra -pedantic -fstack-protector -fPIE -pie -Wl,-z,relro,-z,now -D_FORTIFY_SOURCE=2

sha1collisiondetector: main.c sha1collisiondetection/lib/sha1.c sha1collisiondetection/lib/ubc_check.c
	$(CC) $(CFLAGS) -o $@ $^

.PHONY: clean
clean:
	-rm sha1collisiondetector

.PHONY: test
test: sha1collisiondetector
	./sha1collisiondetector tests/shattered-1.pdf; test $$? = 3
	./sha1collisiondetector tests/shattered-2.pdf; test $$? = 3
	cat tests/shattered-1.pdf | ./sha1collisiondetector; test $$? = 3
	./sha1collisiondetector tests/non-shattered.pdf; test $$? = 0
	cat tests/non-shattered.pdf | ./sha1collisiondetector; test $$? = 0
	./sha1collisiondetector tests/does-not-exist.pdf; test $$? = 1
