//
//  Paragraph+CoreDataProperties.h
//  
//
//  Created by Jake Chong on 16/06/2023.
//
//

#import "Paragraph+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Paragraph (CoreDataProperties)

+ (NSFetchRequest<Paragraph *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *heading;
@property (nullable, nonatomic, copy) NSString *body;

@end

NS_ASSUME_NONNULL_END
