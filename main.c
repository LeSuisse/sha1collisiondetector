/**
 * Copyright (C) 2017 Thomas Gerbet
 * Copyright 2017 Marc Stevens <marc@marc-stevens.nl>, Dan Shumow <danshu@microsoft.com>
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

#include <stdio.h>
#include "sha1collisiondetection/lib/sha1.h"

int main(int argc, char** argv)
{
    FILE* fd;
    SHA1_CTX sha1_context;
    unsigned char hash[20];
    char buffer[65536];
    size_t size;

    int foundcollision;

    if (argc < 2) {
        fd = fopen("/dev/stdin", "rb");
    } else {
        fd = fopen(argv[1], "rb");
    }
    if (fd == NULL) {
        return 1;
    }

    SHA1DCInit(&sha1_context);

    while (1) {
        size = fread(buffer, 1, 65536, fd);
        SHA1DCUpdate(&sha1_context, buffer, (unsigned)(size));
        if (size != 65536) {
            break;
        }
    }

    if (ferror(fd)) {
        return 1;
    }
    if (! feof(fd)) {
        return 1;
    }
    fclose(fd);

    foundcollision = SHA1DCFinal(hash, &sha1_context);
    if (foundcollision)
    {
        return 3;
    }

    return 0;
}
