//
//  ViewController.h
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import <UIKit/UIKit.h>
#import "Friend+CoreDataProperties.h"

@protocol FriendViewControllerDelegate <NSObject>

- (BOOL) addFriend:(Friend *) friend;
- (IBAction) discoverablePressed:(id) sender;

@end

@interface FriendViewController : UIViewController <FriendViewControllerDelegate> {
    IBOutlet UITableView * buttonStack;
    NSMutableArray * friendButtonList;
}

@property (retain, nonatomic) UITableView * buttonStack;
@property (retain, nonatomic) IBOutlet UIButton * discoverableButton;

@end

