//
//  Friend+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 31/05/2023.
//
//

#import "Friend+CoreDataProperties.h"

@implementation Friend (CoreDataProperties)

+ (NSFetchRequest<Friend *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
}

@dynamic friendName;
@dynamic deviceID;

@end
