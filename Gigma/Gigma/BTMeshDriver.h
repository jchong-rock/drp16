//
//  BTMeshDriver.h
//  Gigma
//
//  Created by Jake Chong on 06/06/2023.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "Gigma-Swift.h"

#define kLocationServiceUUID @"00001234-0000-1000-8000-00805F9B34FB"

@interface BTMeshDriver : NSObject
    <BluetoothDriver, CBCentralManagerDelegate, CBPeripheralManagerDelegate> {
}

@end
