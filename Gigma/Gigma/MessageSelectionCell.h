//
//  MessageSelectionCell.h
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>
#import "Friend+CoreDataProperties.h"

@interface MessageSelectionCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * friendName;
@property (nonatomic, weak) IBOutlet UILabel * messagePreview;
@property (nonatomic, weak) IBOutlet UILabel * dateTime;
@property (nonatomic, weak) Friend * recipient;

@end
