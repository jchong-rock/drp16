//
//  Friend+CoreDataProperties.h
//  
//
//  Created by Jake Chong on 01/06/2023.
//
//

#import "Friend+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Friend (CoreDataProperties)

+ (NSFetchRequest<Friend *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *friendName;
@property (nullable, nonatomic, copy) NSUUID *deviceID;

@end

NS_ASSUME_NONNULL_END
