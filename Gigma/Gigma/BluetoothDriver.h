//
//  LittleBluetooth.h
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import <Foundation/Foundation.h>
#import "Friend+CoreDataProperties.h"
#import "BluetoothManager.h"

@protocol NearbyDevicePickerDelegate <NSObject>

- (void) addNearbyDevice:(Friend * _Nonnull) friend;

@end

@interface BluetoothDriver : NSObject <BluetoothDataDelegate>

- (void) broadcastName;
- (void) usePeripheral;
- (void) useCentral;
- (void) retrieveData:(NSData * _Nonnull) data;

@property (retain, strong, nonatomic) NSObject <NearbyDevicePickerDelegate> * _Nullable nearbyDevicePickerDelegate;

@end
