//
//  FriendListCell.h
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import <UIKit/UIKit.h>
#import "Friend+CoreDataProperties.h"
#import "FriendViewController.h"
#import "AppDelegate.h"

@interface FriendListCell : UITableViewCell <UIColorPickerViewControllerDelegate> {
    AppDelegate * appDelegate;
}

@property (nonatomic, weak) Friend * friend;
@property (nonatomic, weak) IBOutlet UIButton * colourButton;
@property (nonatomic, weak) IBOutlet UIButton * iconButton;
@property (nonatomic, weak) IBOutlet UIButton * messageButton;
@property (nonatomic, weak) IBOutlet UIButton * locationButton;
@property (nonatomic, weak) NSObject <FriendViewControllerDelegate> * delegate;

@end
