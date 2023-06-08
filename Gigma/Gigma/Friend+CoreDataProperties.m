//
//  Friend+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 08/06/2023.
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
@dynamic messages;

@end
