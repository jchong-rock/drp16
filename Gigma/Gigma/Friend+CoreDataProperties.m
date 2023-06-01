//
//  Friend+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 01/06/2023.
//
//

#import "Friend+CoreDataProperties.h"

@implementation Friend (CoreDataProperties)

+ (NSFetchRequest<Friend *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
}

@dynamic friendName;
@dynamic deviceID;
@dynamic messages;

@end
