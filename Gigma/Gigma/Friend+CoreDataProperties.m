//
//  Friend+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 13/06/2023.
//
//

#import "Friend+CoreDataProperties.h"

@implementation Friend (CoreDataProperties)

+ (NSFetchRequest<Friend *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
}

@dynamic colour;
@dynamic deviceID;
@dynamic friendName;
@dynamic peerID;
@dynamic messages;

@end
