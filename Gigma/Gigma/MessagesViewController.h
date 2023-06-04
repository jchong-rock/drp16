//
//  MessagesViewController.h
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ComposeMessageViewController.h"

@interface MessagesViewController : UIViewController <ComposeMesssageViewControllerDelegate>  {
    IBOutlet UITableView * messageStack;
    NSMutableArray * friendButtonList;
}

@property (retain, nonatomic) UITableView * messageStack;

@end
