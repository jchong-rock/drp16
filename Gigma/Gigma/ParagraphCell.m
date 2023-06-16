//
//  ParagraphCell.m
//  Gigma
//
//  Created by Jake Chong on 16/06/2023.
//

#import <Foundation/Foundation.h>
#import "ParagraphCell.h"

@implementation ParagraphCell

@synthesize body;
@synthesize heading;

- (double) height {
    return CGRectGetHeight(body.frame) + CGRectGetHeight(heading.frame) + PARAGRAPH_PADDING;
}

+ (void) adjustTextViewHeight:(UITextView *) textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits: CGSizeMake(fixedWidth, CGFLOAT_MAX)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

@end
