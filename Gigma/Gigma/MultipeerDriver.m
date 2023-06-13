//
//  MultipeerDriver.m
//  Gigma
//
//  Created by Jake Chong on 12/06/2023.
//

#import "MultipeerDriver.h"

@interface MultipeerDriver ()

@property (retain, nonatomic) MCNearbyServiceAdvertiser * advertiser;
@property (retain, nonatomic) MCNearbyServiceBrowser * browser;
@property (nonatomic, strong) MCSession * session;
@property (nonatomic, strong) MCPeerID * localPeerID;

@end

@implementation MultipeerDriver

@synthesize advertiser;
@synthesize browser;
@synthesize session;
@synthesize localPeerID;

@synthesize connectedPeers;
@synthesize nearbyDevicePickerDelegate;
@synthesize friendViewControllerDelegate;

- (instancetype) init {
    
    self = [super init];
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSData * storedID = [prefs dataForKey: @"peerID"];
    if (storedID != nil) {
        self.localPeerID = [NSKeyedUnarchiver unarchivedObjectOfClass: MCPeerID.class fromData: storedID error: nil];
    } else {
        MCPeerID * peerID = [[MCPeerID alloc] initWithDisplayName: UIDevice.currentDevice.name];
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject: peerID];
        [prefs setObject: data forKey: @"peerID"];
        self.localPeerID = peerID;
    }
    

    session = [[MCSession alloc] initWithPeer: localPeerID securityIdentity: nil encryptionPreference: MCEncryptionNone];
    session.delegate = self;
    
    browser = [[MCNearbyServiceBrowser alloc] initWithPeer: localPeerID serviceType: SERVICE_TYPE];
    browser.delegate = self;
    
    [self.browser startBrowsingForPeers];
    
    return self;
}

- (void) startAdvertising {
    NSDictionary * discoveryInfo = nil;
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer: self.localPeerID discoveryInfo: discoveryInfo serviceType: SERVICE_TYPE];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];
}

- (void) stopAdvertising {
    [self.advertiser stopAdvertisingPeer];
}

- (void) advertiser:(nonnull MCNearbyServiceAdvertiser *) advertiser didReceiveInvitationFromPeer:(nonnull MCPeerID *) peerID withContext:(nullable NSData *) context invitationHandler:(nonnull void (^) (BOOL, MCSession * _Nullable)) invitationHandler {
    
    enum BTOpcode opcode = ((const char *) [context bytes]) [0];
    
    switch (opcode) {
        case NO_OP: {
            break;
        }
        case DECLINE_REQ: {
            NSLog(@"decline request");
            break;
        }
        case FRIEND_REQ: {
            NSLog(@"friend request");
            // ask for accept or decline
            // if accept, send public key
            break;
        }
        case ACCEPT_REQ: {
            NSLog(@"accept request");
            // send back public key
            break;
        }
        case SEND_LOC: {
            
            break;
        }
        case REQ_LOC: {
            
            break;
        }
        case SEND_MSG: {
            
            break;
        }
        case MSG_READ: {
            
            break;
        }
    }
    
    invitationHandler(YES, self.session);
}

// call from AddFriendViewController
- (void) askConnectPeer:(MCPeerID *) peerID withOpcode:(enum BTOpcode) opcode {
    
    [browser invitePeer: peerID toSession: session withContext: [NSData dataWithBytes: &opcode length: sizeof(char)] timeout: 10];
}

- (void) broadcastData:(NSData *) data {
    [session sendData: data toPeers: connectedPeers withMode: MCSessionSendDataUnreliable error: nil];
}

- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer {
    [session sendData: data toPeers: @[peer] withMode: MCSessionSendDataUnreliable error: nil];
}

- (void) browser:(MCNearbyServiceBrowser *) browser foundPeer:(MCPeerID *) peerID withDiscoveryInfo:(NSDictionary <NSString *, NSString *> *) info {
    if (nearbyDevicePickerDelegate != nil) {
        [nearbyDevicePickerDelegate addNearbyDevice: peerID];
    }
}

- (void) browser:(nonnull MCNearbyServiceBrowser *) browser lostPeer:(nonnull MCPeerID *) peerID {
    if (nearbyDevicePickerDelegate != nil) {
        [nearbyDevicePickerDelegate removeNearbyDevice: peerID];
    }
}

- (void) session:(nonnull MCSession *) session didFinishReceivingResourceWithName:(nonnull NSString *) resourceName fromPeer:(nonnull MCPeerID *) peerID atURL:(nullable NSURL *) localURL withError:(nullable NSError *) error {
    
}

- (void) session:(nonnull MCSession *) session didReceiveStream:(nonnull NSInputStream *) stream withName:(nonnull NSString *) streamName fromPeer:(nonnull MCPeerID *) peerID {
    
}

- (void) session:(nonnull MCSession *) session didStartReceivingResourceWithName:(nonnull NSString *) resourceName fromPeer:(nonnull MCPeerID *) peerID withProgress:(nonnull NSProgress *) progress {
    
}

- (void) session:(MCSession *) session didReceiveCertificate:(NSArray *) certificate fromPeer:(MCPeerID *) peerID certificateHandler:(void (^) (BOOL accept)) certificateHandler {
     if (certificateHandler != nil) {
         certificateHandler(YES);
     }
}

- (void) session:(nonnull MCSession *) session didReceiveData:(nonnull NSData *) data fromPeer:(nonnull MCPeerID *) peerID {
    NSLog(@"%@", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
}

- (void) session:(nonnull MCSession *) session peer:(nonnull MCPeerID *) peerID didChangeState:(MCSessionState) state {
    if (state == MCSessionStateConnected) {
        NSLog(@"connect");
        [self.connectedPeers addObject: peerID];
    } else if (state == MCSessionStateNotConnected) {
        NSLog(@"unconnect");
        [self.connectedPeers removeObject: peerID];
    } else {
        NSLog(@"innit");
    }
}

@end
