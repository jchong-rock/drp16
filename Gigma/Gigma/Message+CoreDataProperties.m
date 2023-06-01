//
//  Message+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 01/06/2023.
//
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Message"];
}

@dynamic contents;
@dynamic dateTime;
@dynamic weSentIt;
@dynamic wasRead;
@dynamic recipient;

@end
