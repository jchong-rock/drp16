//
//  MultipeerDriver.m
//  Gigma
//
//  Created by Jake Chong on 12/06/2023.
//

#import "MultipeerDriver.h"
#import "RSAManager.h"
#import "FriendViewController.h"
#import "AppDelegate.h"

@interface MultipeerDriver ()

@property (retain, nonatomic) MCNearbyServiceAdvertiser * advertiser;
@property (retain, nonatomic) MCNearbyServiceBrowser * browser;
@property (nonatomic, strong) MCSession * session;
@property (nonatomic, strong) MCPeerID * localPeerID;
@property (nonatomic, weak) RSAManager * rsaManager;

@end

@implementation MultipeerDriver

@synthesize advertiser;
@synthesize browser;
@synthesize session;
@synthesize localPeerID;
@synthesize rsaManager;

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
    
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    rsaManager = appDelegate.rsaManager;

    session = [[MCSession alloc] initWithPeer: localPeerID securityIdentity: nil encryptionPreference: MCEncryptionRequired];
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

- (void) sendFriendReqToPeer:(MCPeerID *) peerID {
    NSString * dataString = [[self->rsaManager.publicKeyExponent stringByAppendingString: KEY_SEPARATOR] stringByAppendingString: self->rsaManager.publicKeyModulus];
    
    [self askConnectPeer: peerID withOpcode: FRIEND_REQ andData: [dataString dataUsingEncoding: NSUTF8StringEncoding]];
}

- (NSString *) extractPubKeyFromRawData:(NSData *) context {
    NSRange range = NSMakeRange(1, [context length] - 1);
    NSString * data = [[NSString alloc] initWithData: [context subdataWithRange: range] encoding: NSUTF8StringEncoding];
    NSArray * pubKeyData = [data componentsSeparatedByString: KEY_SEPARATOR];
    NSString * pubKeyExp = [pubKeyData objectAtIndex: 0];
    NSString * pubKeyMod = [pubKeyData objectAtIndex: 1];
    return [rsaManager publicKeyWithModulus: pubKeyMod andExponent: pubKeyExp];
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
            
            UIAlertController * popup = [UIAlertController alertControllerWithTitle: @"Friend request" message: peerID.displayName preferredStyle: UIAlertControllerStyleAlert];
                NSString * pubKey = [self extractPubKeyFromRawData: context];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle: @"Accept" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {
                [self->friendViewControllerDelegate addFriend: peerID.displayName withPubKey: pubKey];
                
                // merge our pubkey parts with :: separator
                NSString * dataString = [[self->rsaManager.publicKeyExponent stringByAppendingString: KEY_SEPARATOR] stringByAppendingString: self->rsaManager.publicKeyModulus];
                
                [self askConnectPeer: peerID withOpcode: ACCEPT_REQ andData: [dataString dataUsingEncoding: NSUTF8StringEncoding]];
                
            }];
            
            UIAlertAction * cancel = [UIAlertAction actionWithTitle: @"Decline" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {}];
            
            [popup addAction: ok];
            [popup addAction: cancel];
            [friendViewControllerDelegate showPopup: popup withCompletion: nil];
            
            break;
            
            // ask for accept or decline
            // if accept, send public key
        }
        case ACCEPT_REQ: {
            NSLog(@"accept request");
            // send back public key
            NSString * pubKey = [self extractPubKeyFromRawData: context];
            [friendViewControllerDelegate addFriend: peerID.displayName withPubKey: pubKey];
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
- (void) askConnectPeer:(MCPeerID *) peerID withOpcode:(enum BTOpcode) opcode andData:(NSData * _Nullable) data {
    NSMutableData * mutableData = [NSMutableData dataWithBytes: &opcode length: sizeof(char)];
    if (data != nil) {
        [mutableData appendData: data];
    }
    [browser invitePeer: peerID toSession: session withContext: mutableData timeout: 10];
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
