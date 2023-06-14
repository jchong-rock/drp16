//
//  MessageDriver.m
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import "MessageDriver.h"
#import "AppDelegate.h"
#import "MultipeerDriver.h"

@interface FakeMessageSender ()

@property (nonatomic, weak) MultipeerDriver * multipeerDriver;

@end

@implementation FakeMessageSender

@synthesize managedObjectContext;
@synthesize multipeerDriver;

// change to use real method
- (Message *) sendMessage:(NSString *) content toFriend:(Friend *) friend {
    if (content != nil && [content length] > 0) {
        
        NSString * dataString = [multipeerDriver getEncryptedMess: [multipeerDriver encryptTextMess: (NSString*) content] forFriend: friend];
        NSData * data = [dataString dataUsingEncoding: NSUTF8StringEncoding];
        [multipeerDriver broadcastData: data withOpcode: SEND_MSG];
        
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

- (instancetype) init {
    self = [super init];
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    multipeerDriver = appDelegate.multipeerDriver;
    managedObjectContext = appDelegate.persistentContainer.viewContext;
    return self;
}

@end
