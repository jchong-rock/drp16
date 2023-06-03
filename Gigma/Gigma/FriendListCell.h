//
//  FriendListCell.h
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import <UIKit/UIKit.h>
#import "Friend+CoreDataProperties.h"

@interface FriendListCell : UITableViewCell

@property (nonatomic, weak) Friend * friend;

@end
