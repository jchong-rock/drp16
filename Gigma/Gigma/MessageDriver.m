//
//  MessageDriver.m
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import "MessageDriver.h"

@implementation FakeMessageSender

@synthesize managedObjectContext;

// change to use real method
- (Message *) sendMessage:(NSString *) content toFriend:(Friend *) friend {
    if (content != nil && [content length] > 0) {
        Message * message = [NSEntityDescription insertNewObjectForEntityForName: @"Message" inManagedObjectContext: managedObjectContext];
        message.recipient = friend;
        message.dateTime = [NSDate date];
        message.weSentIt = YES;
        message.wasRead = NO;
        message.contents = content;
        NSError * error;
        [managedObjectContext save: &error];
        return message;
    }
    return nil;
}

- (instancetype) initWithContext:(NSManagedObjectContext *) context {
    self.managedObjectContext = context;
    return self;
}

@end
