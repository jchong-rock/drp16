//
//  Pair.h
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import <Foundation/Foundation.h>

@interface Pair <T, S> : NSObject

@property T first;
@property S second;

- (instancetype) initWithFirst:(T) a andSecond:(S) b;

@end
