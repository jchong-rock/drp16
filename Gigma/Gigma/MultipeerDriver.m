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
#import "MainViewController.h"
#import "Message+CoreDataProperties.h"
#import "ComposeMessageViewController.h"

@interface MultipeerDriver () {
    NSManagedObjectContext * managedObjectContext;
    dispatch_semaphore_t recentThreadsSemaphore;
    NSUInteger recentThreads [MOST_RECENT_THREADS];
    NSUInteger recentThreadsIndex;
}

@property (retain, nonatomic) MCNearbyServiceAdvertiser * advertiser;
@property (retain, nonatomic) MCNearbyServiceBrowser * browser;
@property (nonatomic, strong) MCSession * session;
@property (nonatomic, strong) MCPeerID * localPeerID;
@property (nonatomic, weak) RSAManager * rsaManager;
@property (nonatomic, weak) AppDelegate * appDelegate;

@end

@implementation MultipeerDriver

@synthesize advertiser;
@synthesize browser;
@synthesize session;
@synthesize localPeerID;
@synthesize rsaManager;
@synthesize nearbyPeers;

@synthesize connectedPeers;
@synthesize nearbyDevicePickerDelegate;
@synthesize friendViewControllerDelegate;
@synthesize updateLocationDelegate;
@synthesize composeDelegate;
@synthesize appDelegate;

- (instancetype) init {
    
    self = [super init];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    rsaManager = appDelegate.rsaManager;
    managedObjectContext = appDelegate.persistentContainer.viewContext;
    recentThreadsIndex = 0;
    recentThreadsSemaphore = dispatch_semaphore_create(1);
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSData * storedID = [prefs dataForKey: @"peerID"];
    nearbyPeers = [[NSMutableArray alloc] init];
    if (storedID != nil) {
        self.localPeerID = [NSKeyedUnarchiver unarchivedObjectOfClass: MCPeerID.class fromData: storedID error: nil];
        printf("hhh");
        NSLog(@"%@", self.localPeerID);
    } else {
        MCPeerID * peerID = [[MCPeerID alloc] initWithDisplayName: rsaManager.name];
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject: peerID];
        [prefs setObject: data forKey: @"peerID"];
        self.localPeerID = peerID;
    }

    session = [[MCSession alloc] initWithPeer: localPeerID securityIdentity: nil encryptionPreference: MCEncryptionRequired];
    session.delegate = self;
    
    browser = [[MCNearbyServiceBrowser alloc] initWithPeer: localPeerID serviceType: SERVICE_TYPE];
    browser.delegate = self;
    
    [self.browser startBrowsingForPeers];
    [self broadcastLocation];
    
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
    
    [self sendToPeer: peerID withOpcode: FRIEND_REQ andData: [dataString dataUsingEncoding: NSUTF8StringEncoding]];
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
    
    dispatch_semaphore_wait(recentThreadsSemaphore, DISPATCH_TIME_FOREVER);
    BOOL foundThread = NO;
    for (int i = 0; i < MOST_RECENT_THREADS; i++) {
        if (recentThreads[i] == context.hash) {
            foundThread = YES;
            break;
        }
    }
    if (!foundThread) {
        recentThreads[recentThreadsIndex++] = context.hash;
        if (recentThreadsIndex == MOST_RECENT_THREADS) {
            recentThreadsIndex = 0;
        }
        if (recentThreadsIndex > MOST_RECENT_THREADS) {
            NSLog(@"race condition detected in multipeerdriver");
        }
    }
    dispatch_semaphore_signal(recentThreadsSemaphore);
    
    enum BTOpcode opcode = ((const char *) [context bytes]) [0];
    NSLog(@"%u", opcode);
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
                [self->friendViewControllerDelegate addFriend: peerID withPubKey: pubKey];
                
                // merge our pubkey parts with :: separator
                NSString * dataString = [[self->rsaManager.publicKeyExponent stringByAppendingString: KEY_SEPARATOR] stringByAppendingString: self->rsaManager.publicKeyModulus];
                NSLog(@"my unwrapped key %@", dataString);
                
                [self sendToPeer: peerID withOpcode: ACCEPT_REQ andData: [dataString dataUsingEncoding: NSUTF8StringEncoding]];
                
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
            [friendViewControllerDelegate addFriend: peerID withPubKey: pubKey];
            break;
        }
        case SEND_LOC: {
            NSLog(@"sendlocation");
            
            [self rebroadcastData: context];
            NSLog(@"context sendlocation is %@", context);
            NSRange range = NSMakeRange(1 + sizeof(unsigned char), [context length] - 1 - sizeof(unsigned char));
            NSString * data = [[NSString alloc] initWithData: [context subdataWithRange: range] encoding: NSUTF8StringEncoding];
            
            NSString * decrypted = [rsaManager decryptString: data];
            NSLog(@"decrypted %@", decrypted);
            
            if (decrypted == nil || [decrypted length] == 0) {
                NSLog(@"nil");
                break;
            }
            NSString * magic = [decrypted substringToIndex: [RSA_MAGIC length]];
            if (![magic isEqual: RSA_MAGIC]) {
                NSLog(@"magic %@", magic);
                break;
            }
            NSLog(@"locationfound");
            
            NSString * peerHash = [decrypted substringWithRange: NSMakeRange([RSA_MAGIC length], 16)];
            NSUInteger peerInt = strtoull([peerHash UTF8String], NULL, 16);
            NSArray * friends = [MainViewController getFriendsFromContext: managedObjectContext];
            for (Friend * friend in friends) {
                if (friend.peerID == peerInt) {
                    NSLog(@"here");
                    NSString * latLong = [decrypted substringFromIndex: [RSA_MAGIC length] + 16];
                    NSString * latLongDec = [rsaManager decryptString: latLong withPublicKey: friend.deviceID];
                    
                    NSString * latString = [latLongDec substringToIndex: 16];
                    NSString * longString = [latLongDec substringFromIndex: 16];
                    
                    NSUInteger latInt = strtoull([latString UTF8String], NULL, 16);
                    NSUInteger longInt = strtoull([longString UTF8String], NULL, 16);
                    
                    union doubleThingy latThingy;
                    union doubleThingy longThingy;
                    
                    latThingy.uinteger = latInt;
                    longThingy.uinteger = longInt;

                    double latitude = latThingy.value;
                    double longitude = longThingy.value;
                    if (updateLocationDelegate != nil) {
                        friend.latitude = latitude;
                        friend.longitude = longitude;
                        [updateLocationDelegate setLatitude: latitude andLongitude: longitude ofFriend: friend];
                    }
                    break;
                }
            }
            
            break;
        }
        case BEACON_LOC: {
            NSLog(@"sendlocationbeacon");
            
            [self rebroadcastData: context];
            NSLog(@"context sendlocation is %@", context);
            NSRange range = NSMakeRange(1 + sizeof(unsigned char), [context length] - 1 - sizeof(unsigned char));
            NSString * data = [[NSString alloc] initWithData: [context subdataWithRange: range] encoding: NSUTF8StringEncoding];
            
            NSString * decrypted = [rsaManager decryptString: data];
            NSLog(@"decrypted %@", decrypted);
            
            if (decrypted == nil || [decrypted length] == 0) {
                NSLog(@"nil");
                break;
            }
            NSString * magic = [decrypted substringToIndex: [RSA_MAGIC length]];
            if (![magic isEqual: RSA_MAGIC]) {
                NSLog(@"magic %@", magic);
                break;
            }
            NSLog(@"locationfound33333");
            
            NSString * peerHash = [decrypted substringWithRange: NSMakeRange([RSA_MAGIC length], 16)];
            NSUInteger peerInt = strtoull([peerHash UTF8String], NULL, 16);
            NSArray * friends = [MainViewController getFriendsFromContext: managedObjectContext];
            for (Friend * friend in friends) {
                if (friend.peerID == peerInt) {
                    NSLog(@"here");
                    NSString * latLong = [decrypted substringFromIndex: [RSA_MAGIC length] + 16];
                    NSString * latLongDec = [rsaManager decryptString: latLong withPublicKey: friend.deviceID];
                    
                    NSString * latString = [latLongDec substringToIndex: 16];
                    NSString * longString = [latLongDec substringFromIndex: 16];
                    
                    NSUInteger latInt = strtoull([latString UTF8String], NULL, 16);
                    NSUInteger longInt = strtoull([longString UTF8String], NULL, 16);
                    
                    union doubleThingy latThingy;
                    union doubleThingy longThingy;
                    
                    latThingy.uinteger = latInt;
                    longThingy.uinteger = longInt;

                    double latitude = latThingy.value;
                    double longitude = longThingy.value;
                    
                    UIAlertController * popup = [UIAlertController alertControllerWithTitle: @"Beacon" message: [[NSString alloc] initWithFormat: @"Alert from %@", friend.friendName] preferredStyle: UIAlertControllerStyleAlert];
                    
                    NSLog (@"beaconeddd");
                    
                    UIAlertAction * ok = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {}];
                    
                    [popup addAction: ok];
                    [appDelegate.currentViewController presentViewController: popup animated: YES completion: nil];
                    
                    break;
                }
            }
            
            break;
        }
        case SEND_MSG: {
            NSLog(@"context sendmsg is %@", context);
            NSLog(@"contextsendmsg %x", *((unsigned char *)[context bytes]+sizeof(char)));
            NSRange range = NSMakeRange(1 + sizeof(unsigned char), [context length] - sizeof(unsigned char) - 1);
            NSString * data = [[NSString alloc] initWithData: [context subdataWithRange: range] encoding: NSUTF8StringEncoding];
            
            NSString * decrypted = [rsaManager decryptString: data];
            if (decrypted == nil || [decrypted length] == 0) {
                NSLog(@"nilmsg");
                break;
            }
            NSString * magic = [decrypted substringToIndex: [RSA_MAGIC length]];
            if (![magic isEqual: RSA_MAGIC]) {
                NSLog(@"magic msg");
                break;
            }
            
            NSLog(@"caught msg");
            
            NSString * peerHash = [decrypted substringWithRange: NSMakeRange([RSA_MAGIC length], 16)];
            NSUInteger peerInt = strtoull([peerHash UTF8String], NULL, 16);
            NSArray * friends = [MainViewController getFriendsFromContext: managedObjectContext];
            for (Friend * friend in friends) {
                if (friend.peerID == peerInt) {
                    NSLog(@"here msg");
                    NSString * text = [decrypted substringFromIndex: [RSA_MAGIC length] + 16];
                    NSString * messageDec = [rsaManager decryptString: text withPublicKey: friend.deviceID];
                    
                    Message * message = [NSEntityDescription insertNewObjectForEntityForName: @"Message" inManagedObjectContext: managedObjectContext];
                    message.recipient = friend;
                    message.dateTime = [NSDate date];
                    message.weSentIt = NO;
                    message.wasRead = YES;
                    message.contents = messageDec;
                    NSError * error;
                    [managedObjectContext save: &error];
                    [composeDelegate refreshWithMessage: message];
                    
                    NSDictionary * userInfo = @{@"message": message};
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"Message Received" object: nil userInfo: userInfo];
                    break;
                }
            }
            
            
            break;
        }
        case MSG_READ: {
            
            break;
        }
    }
    
    invitationHandler(YES, self.session);
}


// call from AddFriendViewController
- (void) sendToPeer:(MCPeerID *) peerID withOpcode:(enum BTOpcode) opcode andData:(NSData * _Nullable) data {
    NSMutableData * mutableData = [NSMutableData dataWithBytes: &opcode length: sizeof(char)];
    if (data != nil) {
        [mutableData appendData: data];
    }
    [browser invitePeer: peerID toSession: session withContext: mutableData timeout: 10];
}

- (void) rebroadcastData:(NSData *) data {
    if (data != nil) {
        unsigned char * ttlPtr = (unsigned char *) ([data bytes] + sizeof(char));
        unsigned char time = *ttlPtr;
        NSLog(@"ttl received: %d", time);
        if (time > 0) {
            time--;
            NSMutableData * ttl = [NSMutableData dataWithBytes: &time length: sizeof(unsigned char)];
            
            NSRange range = NSMakeRange(1 + sizeof(unsigned char), [data length] - sizeof(unsigned char) - 1);
            NSLog(@"crash");
            NSData * context = [data subdataWithRange: range];
            [ttl appendData: context];
            enum BTOpcode opcode = ((const char *) [data bytes]) [0];
            [self broadcastData: ttl withOpcode: opcode];
        }
    }
}

- (NSString *) getEncryptedLoc {
    CLLocationCoordinate2D usercordinate = [updateLocationDelegate getUserLocation];
    double longitude = usercordinate.longitude;
    double latitude = usercordinate.latitude;
    
    union doubleThingy latThingy;
    union doubleThingy longThingy;
    
    latThingy.value = latitude;
    longThingy.value = longitude;
    
    NSUInteger latInt = latThingy.uinteger;
    NSUInteger longInt = longThingy.uinteger;
    
    NSString * latString = [NSString stringWithFormat: @"%016lx", latInt];
    NSString * longString = [NSString stringWithFormat: @"%016lx", longInt];
    
    NSString * latLongString = [latString stringByAppendingString: longString];
    
    return [rsaManager encryptString: latLongString];
    
}

- (NSString *) getEncryptedMess:(NSString *) encrLoc forFriend:(Friend *) friend {
    NSUInteger hash = localPeerID.hash;
    NSString * hashString = [NSString stringWithFormat: @"%016lx", hash];
    NSLog(@"hashString %@", hashString);
    NSString * unencryptData = [[RSA_MAGIC stringByAppendingString: hashString] stringByAppendingString: encrLoc];
    
    return [rsaManager encryptString: unencryptData withPublicKey: friend.deviceID];
}

- (NSString *) encryptTextMess: (NSString *) content {
    return [rsaManager encryptString:content];
}

- (void) broadcastLocation {
    NSArray * friends = [MainViewController getFriendsFromContext: managedObjectContext];
    
    for (Friend * friend in friends) {
        NSString * dataString = [self getEncryptedMess: [self getEncryptedLoc] forFriend: friend];
        unsigned char timeToLive = TIME_TO_LIVE;
        NSMutableData * data = [[NSMutableData alloc] initWithBytes: &timeToLive length: sizeof(unsigned char)];
        [data appendData: [dataString dataUsingEncoding: NSUTF8StringEncoding]];
        [self broadcastData: data withOpcode: SEND_LOC];
    }
    
    [NSTimer scheduledTimerWithTimeInterval: 6.0f
                                     target: self
                                   selector: @selector(broadcastLocation)
                                   userInfo: nil
                                    repeats: NO];
}

- (void) beaconLocation {
    NSArray * friends = [MainViewController getFriendsFromContext: managedObjectContext];
    
    for (Friend * friend in friends) {
        NSString * dataString = [self getEncryptedMess: [self getEncryptedLoc] forFriend: friend];
        unsigned char timeToLive = TIME_TO_LIVE;
        NSMutableData * data = [[NSMutableData alloc] initWithBytes: &timeToLive length: sizeof(unsigned char)];
        [data appendData: [dataString dataUsingEncoding: NSUTF8StringEncoding]];
        [self broadcastData: data withOpcode: BEACON_LOC];
    }
}

- (void) broadcastMessage:(NSString *) message toFriend:(Friend *) friend {
    NSString * dataString = [self getEncryptedMess: [self encryptTextMess: message] forFriend: friend];
    unsigned char timeToLive = TIME_TO_LIVE;
    NSMutableData * data = [[NSMutableData alloc] initWithBytes: &timeToLive length: sizeof(unsigned char)];
    [data appendData: [dataString dataUsingEncoding: NSUTF8StringEncoding]];
    [self broadcastData: data withOpcode: SEND_MSG];
}

- (void) broadcastData:(NSData *) data withOpcode:(enum BTOpcode) opcode {
    NSMutableData * mutableData = [NSMutableData dataWithBytes: &opcode length: sizeof(char)];
    if (data != nil) {
        [mutableData appendData: data];
    }
    for (MCPeerID * peer in nearbyPeers) {
        NSLog(@"peer %@", peer);
        [browser invitePeer: peer toSession: session withContext: mutableData timeout: 10];
    }
}

- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer {
    [session sendData: data toPeers: @[peer] withMode: MCSessionSendDataUnreliable error: nil];
}

- (void) browser:(MCNearbyServiceBrowser *) browser foundPeer:(MCPeerID *) peerID withDiscoveryInfo:(NSDictionary <NSString *, NSString *> *) info {
    if (nearbyDevicePickerDelegate != nil) {
        [nearbyDevicePickerDelegate addNearbyDevice: peerID];
    }
    NSLog(@"added peer %@", peerID);
    [nearbyPeers addObject: peerID];
}

- (void) browser:(nonnull MCNearbyServiceBrowser *) browser lostPeer:(nonnull MCPeerID *) peerID {
    if (nearbyDevicePickerDelegate != nil) {
        [nearbyDevicePickerDelegate removeNearbyDevice: peerID];
    }
    NSLog(@"removed peer %@", peerID);
    [nearbyPeers removeObject: peerID];
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
}

@end
