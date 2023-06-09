//
//  LittleBluetooth.m
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import "BluetoothDriver.h"
#import "Gigma-Swift.h"
#import "BluetoothManager.h"
#import "RSAManager.h"

@interface BluetoothDriver () {
    BOOL inPeripheralMode;
    NSString * nearbyName;
}

@property (nonatomic, retain) CentralManagerAdapter * centralManager;
@property (nonatomic, retain) PeripheralManagerAdapter * peripheralManager;
@property (weak, atomic) NSObject <BluetoothManager> * currentManager;
@property (weak, atomic) RSAManager * rsaManager;
@property (nonatomic, strong) dispatch_semaphore_t acceptFriendSemaphore;

@end

@implementation BluetoothDriver

@synthesize centralManager;
@synthesize peripheralManager;
@synthesize currentManager;
@synthesize nearbyDevicePickerDelegate;
@synthesize friendViewControllerDelegate;
@synthesize rsaManager;
@synthesize acceptFriendSemaphore;

- (instancetype) init {
    self = [super init];
    centralManager = [[CentralManagerAdapter alloc] initWithDataDelegate: self];
    peripheralManager = [[PeripheralManagerAdapter alloc] init];
    currentManager = centralManager;
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    rsaManager = appDelegate.rsaManager;
    inPeripheralMode = NO;
    [currentManager open];
    return self;
}

- (void) useCentral {
    [currentManager close];
    currentManager = centralManager;
    inPeripheralMode = NO;
    [currentManager open];
}

- (void) usePeripheral {
    [currentManager close];
    currentManager = peripheralManager;
    inPeripheralMode = YES;
    [currentManager open];
}

- (void) sendFriendRequest {
    if (inPeripheralMode) {
        NSString * pubKey = [rsaManager.publicKey stringByPaddingToLength: PUB_KEY_SIZE/4 withString: @" "  startingAtIndex: 0];
        NSData * pk = [pubKey dataUsingEncoding: NSUTF8StringEncoding];
        NSMutableData * data1 = [NSMutableData dataWithData: pk];
        NSData * data2 = [rsaManager.name dataUsingEncoding: NSUTF8StringEncoding];
        [data1 appendData: data2];
        [currentManager sendData: data2 withOpcode: FRIEND_REQ];
    }
}

- (void) broadcastName {
    if (inPeripheralMode) {
        NSString * pubKey = [rsaManager.publicKey stringByPaddingToLength: PUB_KEY_SIZE/4 withString: @" "  startingAtIndex: 0];
        NSData * pk = [pubKey dataUsingEncoding: NSUTF8StringEncoding];
        NSMutableData * data1 = [NSMutableData dataWithData: pk];
        NSLog(@"RSA key: %@ ::::::: with Length: %lu", pubKey, (unsigned long)[pubKey length]);
        NSData * data2 = [rsaManager.name dataUsingEncoding: NSUTF8StringEncoding];
        [data1 appendData: data2];
        NSLog(@"rsadatalength: %lu", (unsigned long) [data1 length]);
        [currentManager sendData: data1 withOpcode: PUB_KEY];
    }
}

- (CodableCoordinate * _Nonnull) getLocationWithPubKey:(NSData * _Nonnull) pubKey {
    return nil;
}

- (void) retrieveData:(NSData * _Nonnull) data {
    // switch on the first byte -- opcode
    // if the opcode is a message or location, forward the data, then check if it is intended for us
    // if the opcode is a friend request, call the appropriate method to prompt confirmation from the user
    // if the opcode is a public key, store the rest of the data in the Friend's field, then if we have not shared our public key with this friend, share our public key.
    const unsigned char firstByte = ((const unsigned char *) [data bytes]) [0];
    switch (firstByte) {
        case PUB_KEY: {
            
            acceptFriendSemaphore = dispatch_semaphore_create(0);
                
            NSUInteger dataLength = [data length];
            NSData * pubKeyData = [data subdataWithRange: NSMakeRange(1, PUB_KEY_SIZE/4)];
            NSData * friendNameData = [data subdataWithRange: NSMakeRange((PUB_KEY_SIZE/4) + 1, dataLength - (PUB_KEY_SIZE/4) - 1)];
            NSString * friendName = [[NSString alloc] initWithData: friendNameData encoding: NSUTF8StringEncoding];
            NSString * pubKey = [[NSString alloc] initWithData: pubKeyData encoding: NSUTF8StringEncoding];
            
            // Set the timeout interval
            double timeoutInSeconds = 15.0;
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutInSeconds * NSEC_PER_SEC));
            
            // Wait for the semaphore to be signaled or timeout
            long result = dispatch_semaphore_wait(acceptFriendSemaphore, timeout);
            
            if (result == 0) {
                NSLog(@"Completion handler has been called.");
                if (friendViewControllerDelegate != nil) {
                    [friendViewControllerDelegate addFriend: friendName withPubKey: pubKey];
                }
            } else {
                NSLog(@"Timeout occurred.");
            }
            break;
        }
        case FRIEND_REQ: {
            NSUInteger dataLength = [data length];
            NSData * pubKeyData = [data subdataWithRange: NSMakeRange(1, PUB_KEY_SIZE/4)];
            NSData * friendNameData = [data subdataWithRange: NSMakeRange((PUB_KEY_SIZE/4) + 1, dataLength - (PUB_KEY_SIZE/4) - 1)];
            NSString * friendName = [[NSString alloc] initWithData: friendNameData encoding: NSUTF8StringEncoding];
            NSString * pubKey = [[NSString alloc] initWithData: pubKeyData encoding: NSUTF8StringEncoding];
            __block BOOL accepted;
            UIAlertController * popup = [UIAlertController alertControllerWithTitle: @"Friend Request" message: friendName preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction actionWithTitle: @"Accept" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {accepted = YES;}];
            UIAlertAction * cancel = [UIAlertAction actionWithTitle: @"Decline" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {accepted = NO;}];
            
            [popup addAction: ok];
            [popup addAction: cancel];
            if (friendViewControllerDelegate != nil) {
                [friendViewControllerDelegate showPopup: popup withCompletion: nil];
                if (accepted) {
                    [friendViewControllerDelegate addFriend: friendName withPubKey: pubKey];
                    [self usePeripheral];
                    [currentManager sendData: [@" " dataUsingEncoding: NSUTF8StringEncoding] withOpcode: ACCEPT_REQ];
                    [self useCentral];
                }
                break;
            }
        }
        case ACCEPT_REQ: {
            if (self.acceptFriendSemaphore != nil) {
                dispatch_semaphore_signal(self.acceptFriendSemaphore);
                self.acceptFriendSemaphore = nil;
            }
            
        }
    }
}

@end
