//
//  LittleBluetooth.m
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import "LittleBluetooth.h"

@interface LittleBluetooth () {
    Bluetoother * bt; // filler code -- DELETE
}

@end

@implementation LittleBluetooth

- (instancetype) init {
    self = [super init];
    bt = [[Bluetoother alloc] init]; // filler code -- DELETE
    return self;
}

- (void) useCentral {
    
}

- (void) usePeripheral {
    
}

- (CodableCoordinate * _Nonnull) getLocationWithUuid:(NSUUID * _Nonnull) uuid {
    return [bt getLocationWithUuid: uuid]; // filler code -- DELETE
}


- (NSDictionary <NSUUID *, NSString *> * _Nonnull) nearbyBluetoothDevices {
    return [bt nearbyBluetoothDevices]; // filler code -- DELETE
}


@end
