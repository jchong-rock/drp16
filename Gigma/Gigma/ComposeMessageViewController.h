//
//  ComposeMessageViewController.h
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import <UIKit/UIKit.h>
#import "IndentedLabel.h"
#import "Friend+CoreDataProperties.h"

@interface ComposeMessageViewController : UIViewController {
    IBOutlet UITableView * messageStack;
    IBOutlet UITextField * textField;
}

@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (retain, nonatomic) UITextField * textField;
@property (retain, nonatomic) UITableView * messageStack;
@property (retain, nonatomic) Friend * recipient;
@property (retain, nonatomic) NSMutableArray * messageList;

- (IBAction) goBack:(id) sender;

@end
