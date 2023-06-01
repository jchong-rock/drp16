//
//  ViewController.h
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import <UIKit/UIKit.h>

@protocol FriendViewControllerDelegate <NSObject>

- (BOOL) addFriend:(NSString *) name withID:(NSUUID *) uid;

@end

@interface FriendViewController : UIViewController <FriendViewControllerDelegate> {
    IBOutlet UITableView * buttonStack;
    NSMutableArray * friendButtonList;
}

@property (retain, nonatomic) UITableView * buttonStack;

@end

