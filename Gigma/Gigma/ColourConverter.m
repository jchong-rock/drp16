//
//  ColourConverter.m
//  Gigma
//
//  Created by bp821 on 08/06/2023.
//

#import "ColourConverter.h"
#define RED_MASK 0x00000000FF000000
#define GREEN_MASK 0x0000000000FF0000
#define BLUE_MASK 0x000000000000FF00
#define ALPHA_MASK 0x00000000000000FF

#define RED_SHIFT 24
#define GREEN_SHIFT 16
#define BLUE_SHIFT 8
#define ALPHA_SHIFT 0
#define SHIFT 8

#define l_shift(NUM, SHIFT) (NUM <<= SHIFT)

#define hex_mask_shift(MASK, SHIFT) ((MASK & castHex) >> SHIFT) / 255

@implementation ColourConverter

+ (int64_t) toHex: (UIColor *) colour {
    CGFloat * redPtr = malloc(sizeof(CGFloat));
    CGFloat * greenPtr = malloc(sizeof(CGFloat));
    CGFloat * bluePtr = malloc(sizeof(CGFloat));
    CGFloat * alphaPtr = malloc(sizeof(CGFloat));
    
    //if guard needed
    BOOL _ = [colour getRed: redPtr green: greenPtr blue: bluePtr alpha: alphaPtr];
    
    int64_t intVal = 0;
    
    intVal |= (uint32_t) (*redPtr * 255);
    intVal <<= SHIFT;
    
    intVal |= (uint32_t) (*greenPtr * 255);
    intVal <<= SHIFT;
    
    intVal |= (uint32_t) (*bluePtr * 255);
    intVal <<= SHIFT;
    
    intVal |= (uint32_t) (*alphaPtr * 255);
    
    free(redPtr);
    free(greenPtr);
    free(bluePtr);
    free(alphaPtr);
    
    return (int64_t) intVal;
}

+ (UIColor *) toColour: (int64_t) hex {
    u_int64_t castHex = (u_int64_t) hex;
    CGFloat red   = (CGFloat) hex_mask_shift(RED_MASK, RED_SHIFT);
    CGFloat green = (CGFloat) hex_mask_shift(GREEN_MASK, GREEN_SHIFT);
    CGFloat blue  = (CGFloat) hex_mask_shift(BLUE_MASK, BLUE_SHIFT);
    CGFloat alpha = (CGFloat) hex_mask_shift(ALPHA_MASK, ALPHA_SHIFT);
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

@end
