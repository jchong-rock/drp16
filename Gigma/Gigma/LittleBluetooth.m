//
//  LittleBluetooth.m
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import "LittleBluetooth.h"
#import "Gigma-Swift.h"
#import "BluetoothManager.h"

@interface LittleBluetooth () {
    Bluetoother * bt; // filler code -- DELETE
    BOOL inPeripheralMode;
}

@property (nonatomic, retain) CentralManagerAdapter * centralManager;
@property (nonatomic, retain) PeripheralManagerAdapter * peripheralManager;
@property (weak, atomic) NSObject <BluetoothManager> * currentManager;

@end

@implementation LittleBluetooth

@synthesize centralManager;
@synthesize peripheralManager;
@synthesize currentManager;

- (instancetype) init {
    self = [super init];
    bt = [[Bluetoother alloc] init]; // filler code -- DELETE
    centralManager = [[CentralManagerAdapter alloc] initWithDataDelegate: self];
    [centralManager sendData: UIDevice.currentDevice.name];
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

- (CodableCoordinate * _Nonnull) getLocationWithUuid:(NSUUID * _Nonnull) uuid {
    return [bt getLocationWithUuid: uuid]; // filler code -- DELETE
}


- (NSDictionary <NSUUID *, NSString *> * _Nonnull) nearbyBluetoothDevices {
    return [bt nearbyBluetoothDevices]; // filler code -- DELETE
}

- (void) broadcastName {
    if (inPeripheralMode) {
        [currentManager sendData: UIDevice.currentDevice.name];
    }
}

- (void) retrieveData:(NSData * _Nonnull) data {
    // switch on the first byte -- opcode
    // if the opcode is a message or location, forward the data, then check if it is intended for us
    // if the opcode is a friend request, call the appropriate method to prompt confirmation from the user
    // if the opcode is a public key, store the rest of the data in the Friend's field, then if we have not shared our public key with this friend, share our public key.
}

@end
