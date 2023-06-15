//
//  BTOpcode.h
//  Gigma
//
//  Created by kup21 on 08/06/2023.
//

#ifndef BTOpcode_h
#define BTOpcode_h

enum BTOpcode {
    NO_OP = 0,
    
    // FRIEND
    FRIEND_REQ,
    ACCEPT_REQ,
    DECLINE_REQ,

    // LOCATION
    SEND_LOC,
    BEACON_LOC,
    
    // MESSAGES
    SEND_MSG,
    MSG_READ
};

union doubleThingy {
    unsigned long uinteger;
    double value;
};

int opcodeValue(enum BTOpcode);
uint64_t uintFromChars(char * chars);
char * charsFromUint(uint64_t value);

#endif /* BTOpcode_h */
