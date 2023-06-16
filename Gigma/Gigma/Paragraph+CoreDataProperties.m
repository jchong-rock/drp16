//
//  Paragraph+CoreDataProperties.m
//  
//
//  Created by Jake Chong on 16/06/2023.
//
//

#import "Paragraph+CoreDataProperties.h"

@implementation Paragraph (CoreDataProperties)

+ (NSFetchRequest<Paragraph *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Paragraph"];
}

@dynamic heading;
@dynamic body;

@end
