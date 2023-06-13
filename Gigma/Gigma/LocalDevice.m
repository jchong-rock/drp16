//
//  LocalDevice.m
//  Gigma
//
//  Created by Jake Chong on 13/06/2023.
//

#import "LocalDevice.h"
#import "MultipeerDriver.h"
#import "AppDelegate.h"
#import "BTOpcode.h"

@interface LocalDevice () {
    MultipeerDriver * multipeerDriver;
}

@end

@implementation LocalDevice

@synthesize session;
@synthesize peerID;
@synthesize state;
@synthesize name;

- (instancetype) initWithPeerID:(MCPeerID *) peer {
    self = [super init];
    
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    multipeerDriver = appDelegate.multipeerDriver;
    
    peerID = peer;
    self.name = peerID.displayName;
    return self;
}

- (void) inviteWithOpcode:(enum BTOpcode) opcode {
    [multipeerDriver askConnectPeer: self.peerID withOpcode: opcode];
}

@end
