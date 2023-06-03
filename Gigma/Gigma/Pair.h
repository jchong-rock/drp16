//
//  Pair.h
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import <Foundation/Foundation.h>

@interface Pair <T> : NSObject

@property T first;
@property T second;

- (instancetype) initWithFirst:(T) a andSecond:(T) b;

@end
