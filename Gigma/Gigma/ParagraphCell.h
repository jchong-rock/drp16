//
//  ParagraphCell.h
//  Gigma
//
//  Created by Jake Chong on 16/06/2023.
//

#import <UIKit/UIKit.h>
#define PARAGRAPH_PADDING 0.0

@interface ParagraphCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView * body;
@property (weak, nonatomic) IBOutlet UILabel * heading;
@property (readonly) double height;

+ (void) adjustTextViewHeight:(UITextView *) textView;

@end
