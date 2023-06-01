//
//  IndentedLabel.m
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import "IndentedLabel.h"

@implementation IndentedLabel

- (void) drawTextInRect:(CGRect) rect {
    UIEdgeInsets insets = self.textInsets;
    [super drawTextInRect: UIEdgeInsetsInsetRect(rect, insets)];
}

@end
