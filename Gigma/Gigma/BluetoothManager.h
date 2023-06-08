//
//  BluetoothManager.h
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import <Foundation/Foundation.h>

@protocol BluetoothManager <NSObject>

- (void) open;
- (void) sendData:(NSString * _Nonnull) data;
- (NSString * _Nullable) receiveData;
- (void) close;

@end

@protocol BluetoothDataDelegate <NSObject>

- (void) retrieveData:(NSData * _Nonnull) data;

@end
