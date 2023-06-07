//
//  BluetoothManager.h
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import <Foundation/Foundation.h>

@protocol BluetoothManager <NSObject>

- (void) sendData:(NSString * _Nonnull) data;
- (NSString * _Nullable) receiveData;

@end
