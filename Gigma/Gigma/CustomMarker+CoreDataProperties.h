//
//  CustomMarker+CoreDataProperties.h
//  
//
//  Created by Jake Chong on 13/06/2023.
//
//

#import "CustomMarker+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CustomMarker (CoreDataProperties)

+ (NSFetchRequest<CustomMarker *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) int64_t colour;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
