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

@interface MultipeerDriver : NSObject <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate>

@property (retain, nonatomic) NSMutableArray <MCPeerID *> * nearbyPeers;
@property (retain, nonatomic) NSMutableArray <MCPeerID *> * connectedPeers;
@property (weak, nonatomic) NSObject <NearbyDevicePickerDelegate> * nearbyDevicePickerDelegate;
@property (weak, nonatomic) NSObject <FriendViewControllerDelegate> * friendViewControllerDelegate;

- (void) startAdvertising;
- (void) stopAdvertising;
- (void) askConnectPeer:(MCPeerID *) peerID withOpcode:(enum BTOpcode) opcode andData:(NSData * _Nullable) data;
- (void) broadcastData:(NSData *) data;
- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer;
- (void) sendFriendReqToPeer:(MCPeerID *) peerID;

@end
