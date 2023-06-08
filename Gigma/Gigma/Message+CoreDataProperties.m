//
//  Message+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 08/06/2023.
//
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Message"];
}

@dynamic contents;
@dynamic dateTime;
@dynamic wasRead;
@dynamic weSentIt;
@dynamic recipient;

@end
