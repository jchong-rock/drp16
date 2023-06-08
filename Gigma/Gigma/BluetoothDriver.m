//
//  LittleBluetooth.m
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import "BluetoothDriver.h"
#import "Gigma-Swift.h"
#import "BluetoothManager.h"

@interface BluetoothDriver () {
    BOOL inPeripheralMode;
    NSString * nearbyName;
}

@property (nonatomic, retain) CentralManagerAdapter * centralManager;
@property (nonatomic, retain) PeripheralManagerAdapter * peripheralManager;
@property (weak, atomic) NSObject <BluetoothManager> * currentManager;

@end

@implementation BluetoothDriver

@synthesize centralManager;
@synthesize peripheralManager;
@synthesize currentManager;
@synthesize nearbyDevicePickerDelegate;

- (instancetype) init {
    self = [super init];
    centralManager = [[CentralManagerAdapter alloc] initWithDataDelegate: self];
    peripheralManager = [[PeripheralManagerAdapter alloc] init];
    currentManager = centralManager;
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


- (NSDictionary <NSUUID *, NSString *> * _Nonnull) nearbyBluetoothDevices {
    return nil;
}

- (void) broadcastName {
    if (inPeripheralMode) {
        NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
        NSInteger rsaPubKey = [prefs integerForKey: @"RSAPublicKey"];
        NSMutableData * data1 = [NSMutableData dataWithBytes: &rsaPubKey length: sizeof(rsaPubKey)];
        NSData * data2 = [UIDevice.currentDevice.name dataUsingEncoding: NSUTF8StringEncoding];
        [data1 appendData: data2];
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
            NSUInteger dataLength = [data length];
            NSData * pubKey = [data subdataWithRange: NSMakeRange(1, PUB_KEY_SIZE)];
            NSData * friendNameData = [data subdataWithRange: NSMakeRange(PUB_KEY_SIZE, dataLength - PUB_KEY_SIZE)];
            NSString * friendName = [[NSString alloc] initWithData: friendNameData encoding:NSUTF8StringEncoding];
            Friend * friend = [[Friend alloc] init];
            friend.friendName = friendName;
            friend.deviceID = pubKey;
            [nearbyDevicePickerDelegate addNearbyDevice: friend];
            break;
        }
    }
}

@end
