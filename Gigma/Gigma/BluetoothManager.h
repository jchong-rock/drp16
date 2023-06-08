//
//  BluetoothManager.h
//  Gigma
//
//  Created by Jake Chong on 07/06/2023.
//

#import <Foundation/Foundation.h>
#import "BTOpcode.h"

@protocol BluetoothManager <NSObject>

- (void) open;
- (void) sendData:(NSData * _Nonnull) data withOpcode: (enum BTOpcode) opcode;
- (void) close;

@end

@protocol BluetoothDataDelegate <NSObject>

- (void) retrieveData:(NSData * _Nonnull) data;

@end
