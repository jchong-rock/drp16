//
//  Friend+CoreDataProperties.h
//  
//
//  Created by Jake Chong on 08/06/2023.
//
//

#import "Friend+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Friend (CoreDataProperties)

+ (NSFetchRequest<Friend *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) int64_t colour;
@property (nullable, nonatomic, retain) NSData *deviceID;
@property (nullable, nonatomic, copy) NSString *friendName;
@property (nullable, nonatomic, retain) NSOrderedSet<Message *> *messages;

@end

@interface Friend (CoreDataGeneratedAccessors)

- (void)insertObject:(Message *)value inMessagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessagesAtIndex:(NSUInteger)idx;
- (void)insertMessages:(NSArray<Message *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessagesAtIndex:(NSUInteger)idx withObject:(Message *)value;
- (void)replaceMessagesAtIndexes:(NSIndexSet *)indexes withMessages:(NSArray<Message *> *)values;
- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSOrderedSet<Message *> *)values;
- (void)removeMessages:(NSOrderedSet<Message *> *)values;

@end

NS_ASSUME_NONNULL_END
