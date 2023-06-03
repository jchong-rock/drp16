//
//  Pair.m
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import "Pair.h"

@implementation Pair

@synthesize first;
@synthesize second;

- (instancetype) initWithFirst:(id) a andSecond:(id) b {
    self.first = a;
    self.second = b;
    return self;
}

@end
