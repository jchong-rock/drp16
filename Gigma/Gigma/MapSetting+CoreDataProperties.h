//
//  MapSetting+CoreDataProperties.h
//  
//
//  Created by Jake Chong on 03/06/2023.
//
//

#import "MapSetting+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MapSetting (CoreDataProperties)

+ (NSFetchRequest<MapSetting *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *prefName;
@property (nonatomic) BOOL enabled;

@end

NS_ASSUME_NONNULL_END
