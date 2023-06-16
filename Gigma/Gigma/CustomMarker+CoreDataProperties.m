//
//  CustomMarker+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 16/06/2023.
//
//

#import "CustomMarker+CoreDataProperties.h"

@implementation CustomMarker (CoreDataProperties)

+ (NSFetchRequest<CustomMarker *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CustomMarker"];
}

@dynamic colour;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic image;

@end
