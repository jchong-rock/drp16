//
//  MessageDriver.h
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import <Foundation/Foundation.h>
#import "Friend+CoreDataProperties.h"
#import "Message+CoreDataProperties.h"

@protocol MessageDriver <NSObject>

- (Message *) sendMessage:(NSString *) content toFriend:(Friend *) friend;

@end

@interface FakeMessageSender : NSObject <MessageDriver>

@property (nonatomic, weak) NSManagedObjectContext * managedObjectContext;

- (instancetype) initWithContext:(NSManagedObjectContext *) context;

@end
