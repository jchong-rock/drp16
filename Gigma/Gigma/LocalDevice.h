//
//  LocalDevice.h
//  Gigma
//
//  Created by Jake Chong on 13/06/2023.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface LocalDevice : NSObject

@property (readonly, nonatomic) MCPeerID * peerID;
@property (strong, nonatomic) MCSession * session;
@property (strong, nonatomic) NSString * name;
@property (nonatomic) MCSessionState * state;

@end
