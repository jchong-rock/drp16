//
//  Message+CoreDataProperties.h
//  
//
//  Created by Jake Chong on 01/06/2023.
//
//

#import "Message+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *contents;
@property (nullable, nonatomic, copy) NSDate *dateTime;
@property (nonatomic) BOOL weSentIt;
@property (nonatomic) BOOL wasRead;
@property (nullable, nonatomic, retain) Friend *recipient;

@end

NS_ASSUME_NONNULL_END
