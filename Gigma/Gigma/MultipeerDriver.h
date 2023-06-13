//
//  MultipeerDriver.h
//  Gigma
//
//  Created by Jake Chong on 12/06/2023.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "BluetoothManager.h"

#define SERVICE_TYPE @"gigma-svc"

@protocol FriendViewControllerDelegate;
@class Friend;

@protocol UpdateLocationDelegate <NSObject>

- (void) setLatitude:(double) latVal andLongitude:(double) longVal ofFriend:(Friend * _Nonnull) friend;

@end

@interface MultipeerDriver : NSObject <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate>

@property (weak, nonatomic) NSObject <UpdateLocationDelegate> * _Nullable updateLocationDelegate;
@property (retain, nonatomic) NSMutableArray <MCPeerID *> * _Nonnull nearbyPeers;
@property (retain, nonatomic) NSMutableArray <MCPeerID *> * _Nonnull connectedPeers;
@property (weak, nonatomic) NSObject <NearbyDevicePickerDelegate> * _Nullable nearbyDevicePickerDelegate;
@property (weak, nonatomic) NSObject <FriendViewControllerDelegate> * _Nullable friendViewControllerDelegate;

- (void) startAdvertising;
- (void) stopAdvertising;
- (void) sendToPeer:(MCPeerID * _Nonnull) peerID withOpcode:(enum BTOpcode) opcode andData:(NSData * _Nullable) data;
- (void) broadcastData:(NSData * _Nullable) data withOpcode:(enum BTOpcode) opcode;
- (void) sendFriendReqToPeer:(MCPeerID * _Nullable) peerID;

@end
