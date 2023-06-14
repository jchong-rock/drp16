//
//  ComposeMessageViewController.h
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import <UIKit/UIKit.h>
#import "IndentedLabel.h"
#import "Friend+CoreDataProperties.h"

@protocol ComposeMesssageViewControllerDelegate

- (void) refresh;
- (void) deleteMessage:(Message *) message;

@end

@protocol ComposeDelegate

- (void) refreshWithMessage:(Message *) message;

@end

@interface ComposeMessageViewController : UIViewController <ComposeDelegate> {
    IBOutlet UITableView * messageStack;
    IBOutlet UITextField * textField;
    IBOutlet UIView * textBar;
    IBOutlet UIButton * backButton;
    IBOutlet UIButton * sendButton;
}

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (retain, nonatomic) UITextField * textField;
@property (retain, nonatomic) UIButton * backButton;
@property (retain, nonatomic) UIButton * sendButton;
@property (retain, nonatomic) UITableView * messageStack;
@property (retain, nonatomic) UIView * textBar;
@property (retain, nonatomic) Friend * recipient;
@property (retain, nonatomic) NSMutableArray * messageList;
@property (retain, nonatomic) UIViewController <ComposeMesssageViewControllerDelegate> * delegate;

- (IBAction) goBack:(id) sender;

@end
