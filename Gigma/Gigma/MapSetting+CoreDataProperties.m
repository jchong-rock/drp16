//
//  MapSetting+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 03/06/2023.
//
//

#import "MapSetting+CoreDataProperties.h"

@implementation MapSetting (CoreDataProperties)

+ (NSFetchRequest<MapSetting *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MapSetting"];
}

@dynamic prefName;
@dynamic enabled;


@end
