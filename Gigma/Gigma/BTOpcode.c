//
//  BTOpcode.c
//  Gigma
//
//  Created by Jake Chong on 08/06/2023.
//

#include <stdio.h>
#include <stdlib.h>
#include "BTOpcode.h"

int opcodeValue(enum BTOpcode btOpcode) {
    return btOpcode;
}

uint64_t uintFromChars(char * chars) {
    uint64_t value = 0;
    for (int i = 0; i < 8; i++) {
        value |= (uint64_t) (chars[i] << (i * 8));
    }
    return value;
}

char * charsFromUint(uint64_t value) {
    char * bytes = malloc(8);
    for (int i = 0; i < 8; i++) {
        bytes[i] = (value >> (i * 8)) & 0xFF;
    }
    return bytes;
}
