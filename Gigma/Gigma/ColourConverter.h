//
//  ColourConverter.h
//  Gigma
//
//  Created by bp821 on 08/06/2023.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColourConverter : NSObject

+ (int64_t) toHex:(UIColor *) colour;
+ (UIColor *) toColour:(int64_t) hex;

@end

