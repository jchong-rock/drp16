//
//  FestivalSettingsViewController.h
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>

@interface FestivalSettingsViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField * textField;

- (IBAction) leaveButtonPressed:(id) sender;
- (IBAction) displayNameDidChangeValue:(id) sender;

@end
