//
//  NSDictionary+NSDictionaryExtension.h
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (NSDictionaryExtension)

- (id) keyAtIndex:(NSInteger) index;

@end


@implementation NSDictionary (NSDictionaryExtension)

- (id) keyAtIndex:(NSInteger) index {
    return [[self allKeys] objectAtIndex: index];
}

@end

NS_ASSUME_NONNULL_END
