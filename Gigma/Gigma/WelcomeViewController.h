//
//  MainViewController.h
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>
#import "Gigma-Swift.h"

@interface WelcomeViewController : UIViewController {
    IBOutlet UITableView * buttonStack;
}

@property (retain, nonatomic) UITableView * buttonStack;
@property NSArray * festivalButtonList;
@property NSObject <DataBaseDriver> * data;

- (IBAction) continueButtonPressed:(id) sender;
- (IBAction) notListedButtonPressed:(id) sender;

@end
