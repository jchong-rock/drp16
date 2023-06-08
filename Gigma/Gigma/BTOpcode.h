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
    
    // PUBLIC KEY
    PUB_KEY,
    
    // FRIEND
    FRIEND_REQ,
    ACCEPT_REQ,

    // LOCATION
    SEND_LOC,
    REQ_LOC,
    
    // MESSAGES
    SEND_MSG,
    MSG_READ
};

int opcodeValue(enum BTOpcode);

#endif /* BTOpcode_h */
