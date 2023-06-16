//
//  FriendListCell.m
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import "FriendListCell.h"
#import "ColourConverter.h"
#import "AppDelegate.h"

@implementation FriendListCell

@synthesize friend;
@synthesize colourButton;
@synthesize delegate;
@synthesize messageButton;
@synthesize locationButton;

- (void) colorPickerViewControllerDidFinish:(UIColorPickerViewController *) viewController {
    [delegate setColour: viewController.selectedColor];
    friend.colour = [ColourConverter toHex: viewController.selectedColor];
    colourButton.tintColor = viewController.selectedColor;
}

- (IBAction) rename:(id) sender {
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Rename Friend" message: nil preferredStyle: UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler: ^(UITextField * textField) {
        textField.placeholder = @"Name";
    }];

    UIAlertAction * okAction = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {
        UITextField * textField = alertController.textFields.firstObject;
        if ([textField.text length] > 0) {
            self.friend.friendName = textField.text;
        } else {
            [self rename: nil];
        }
        [((FriendViewController *) appDelegate.currentViewController) refresh];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleDefault handler: nil];

    [alertController addAction: okAction];
    [alertController addAction: cancelAction];
    
    
    [appDelegate.currentViewController presentViewController: alertController animated: YES completion: nil];
    
    
}

@end
