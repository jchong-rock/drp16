//
//  MapSetting+CoreDataProperties.h
//  
//
//  Created by Jake Chong on 08/06/2023.
//
//

#import "MapSetting+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MapSetting (CoreDataProperties)

+ (NSFetchRequest<MapSetting *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) BOOL enabled;
@property (nullable, nonatomic, copy) NSString *prefName;

@end

NS_ASSUME_NONNULL_END
