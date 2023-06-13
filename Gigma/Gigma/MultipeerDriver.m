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

- (instancetype) init {
    self = [super init];
    
    advertiser = [[MCNearbyServiceAdvertiser alloc] init];
    advertiser.delegate = self;
    
    browser = [[MCNearbyServiceBrowser alloc] init];
    browser.delegate = self;
    
    localPeerID = [[MCPeerID alloc] initWithDisplayName: UIDevice.currentDevice.name];
    session = [[MCSession alloc] initWithPeer: localPeerID securityIdentity: nil encryptionPreference: MCEncryptionNone];
    session.delegate = self;
    
    [self.browser startBrowsingForPeers];
    
    return self;
}

- (void) startAdvertising {
    NSDictionary * discoveryInfo = nil;
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer: self.localPeerID discoveryInfo: discoveryInfo serviceType: SERVICE_TYPE];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];
}

- (void) advertiser:(nonnull MCNearbyServiceAdvertiser *) advertiser didReceiveInvitationFromPeer:(nonnull MCPeerID *) peerID withContext:(nullable NSData *) context invitationHandler:(nonnull void (^) (BOOL, MCSession * _Nullable)) invitationHandler {
    
    enum BTOpcode opcode = ((const char *) [context bytes]) [0];
    
    switch (opcode) {
        case NO_OP: {
            break;
        }
        case DECLINE_REQ: {
            <#code#>
            break;
        }
        case FRIEND_REQ: {
            // ask for accept or decline
            // if accept, send public key
            break;
        }
        case ACCEPT_REQ: {
            // send back public key
            break;
        }
        case SEND_LOC: {
            <#code#>
            break;
        }
        case REQ_LOC: {
            <#code#>
            break;
        }
        case SEND_MSG: {
            <#code#>
            break;
        }
        case MSG_READ: {
            <#code#>
            break;
        }
    }
    
    invitationHandler(YES, self.session);
}

// call from AddFriendViewController
- (void) connectPeer:(MCPeerID *) peerID withOpcode:(enum BTOpcode) opcode {
    [browser invitePeer: peerID toSession: session withContext: [NSData dataWithBytes: &opcode length: sizeof(char)] timeout: 10];
}

- (void) broadcastData:(NSData *) data {
    [session sendData: data toPeers: connectedPeers withMode: MCSessionSendDataUnreliable error: nil];
}

- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer {
    [session sendData: data toPeers: @[peer] withMode: MCSessionSendDataUnreliable error: nil];
}

- (void) browser:(MCNearbyServiceBrowser *) browser foundPeer:(MCPeerID *) peerID withDiscoveryInfo:(NSDictionary <NSString *, NSString *> *) info {
    [nearbyDevicePickerDelegate addNearbyDevice: peerID];
}

- (void) browser:(nonnull MCNearbyServiceBrowser *) browser lostPeer:(nonnull MCPeerID *) peerID {
    [nearbyDevicePickerDelegate removeNearbyDevice: peerID];
}

- (void) session:(nonnull MCSession *) session didFinishReceivingResourceWithName:(nonnull NSString *) resourceName fromPeer:(nonnull MCPeerID *) peerID atURL:(nullable NSURL *) localURL withError:(nullable NSError *) error {
    
}

- (void) session:(nonnull MCSession *) session didReceiveStream:(nonnull NSInputStream *) stream withName:(nonnull NSString *) streamName fromPeer:(nonnull MCPeerID *) peerID {
    
}

- (void) session:(nonnull MCSession *) session didStartReceivingResourceWithName:(nonnull NSString *) resourceName fromPeer:(nonnull MCPeerID *) peerID withProgress:(nonnull NSProgress *) progress {
    
}

- (void) session:(nonnull MCSession *) session didReceiveData:(nonnull NSData *) data fromPeer:(nonnull MCPeerID *) peerID {
    NSLog(@"%@", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
}

- (void) session:(nonnull MCSession *) session peer:(nonnull MCPeerID *) peerID didChangeState:(MCSessionState) state {
    if (state == MCSessionStateConnected) {
        [self.connectedPeers addObject: peerID];
    } else if (state == MCSessionStateNotConnected) {
        [self.connectedPeers removeObject: peerID];
    }
}

@end
