//
//  ColourConverter.h
//  Gigma
//
//  Created by bp821 on 08/06/2023.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColourConverter : NSObject

+ (u_int64_t) toHex: (UIColor *) colour;

+ (UIColor *) toColour: (u_int64_t) hex;

@end

