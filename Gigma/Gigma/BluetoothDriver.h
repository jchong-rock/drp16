//
//  LittleBluetooth.h
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import <Foundation/Foundation.h>
#import "Friend+CoreDataProperties.h"
#import "BluetoothManager.h"

@class CodableCoordinate;

@protocol NearbyDevicePickerDelegate <NSObject>

- (void) addNearbyDevice:(NSString * _Nonnull) friend withPubKey:(NSString * _Nullable) pubKey;

@end

@interface BluetoothDriver : NSObject <BluetoothDataDelegate>

- (void) broadcastName;
- (void) usePeripheral;
- (void) useCentral;
- (void) retrieveData:(NSData * _Nonnull) data;
- (CodableCoordinate * _Nonnull) getLocationWithPubKey:(NSData * _Nonnull) pubKey;

@property (retain, strong, nonatomic) NSObject <NearbyDevicePickerDelegate> * _Nullable nearbyDevicePickerDelegate;

@end
