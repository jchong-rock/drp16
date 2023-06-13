//
//  CustomMarker+CoreDataProperties.h
//  
//
//  Created by kup21 on 13/06/2023.
//
//

#import "CustomMarker+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CustomMarker (CoreDataProperties)

+ (NSFetchRequest<CustomMarker *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t colour;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end

NS_ASSUME_NONNULL_END
