//
//  MessageCell.h
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import <UIKit/UIKit.h>
#import "IndentedLabel.h"

@interface MessageCell : UITableViewCell

@property (nonatomic, weak) IBOutlet IndentedLabel * content;

@end
