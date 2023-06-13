//
//  CustomMarker+CoreDataProperties.m
//  
//
//  Created by kup21 on 13/06/2023.
//
//

#import "CustomMarker+CoreDataProperties.h"

@implementation CustomMarker (CoreDataProperties)

+ (NSFetchRequest<CustomMarker *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CustomMarker"];
}

@dynamic name;
@dynamic colour;
@dynamic latitude;
@dynamic longitude;

@end
