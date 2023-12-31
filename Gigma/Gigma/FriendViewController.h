//
//  ViewController.h
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import <UIKit/UIKit.h>
#import "Friend+CoreDataProperties.h"

@class MCPeerID;

@protocol FriendViewControllerDelegate <NSObject>

- (BOOL) addFriend:(MCPeerID *) friendName withPubKey:(NSString *) pubKey;
- (BOOL) nameAlreadyExists:(NSString *) name;
- (IBAction) discoverablePressed:(id) sender;
- (void) showPopup:(UIViewController *) popup withCompletion:(id) completion;
- (void) refresh;
- (void) deleteFriend:(Friend *) friend;

@end

@interface FriendViewController : UIViewController <FriendViewControllerDelegate> {
    IBOutlet UITableView * buttonStack;
    NSMutableArray * friendButtonList;

}

@property (retain, nonatomic) UITableView * buttonStack;
@property (retain, nonatomic) UIButton * colourButton;
@property (retain, nonatomic) IBOutlet UIButton * discoverableButton;

- (IBAction) iconSelector:(id) sender;
- (IBAction) colourSelector:(id) sender;

@end

