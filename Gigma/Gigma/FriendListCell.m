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

- (instancetype) init {
    self = [super init];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    return self;
}


- (void) colorPickerViewControllerDidFinish:(UIColorPickerViewController *) viewController {
    friend.colour = [ColourConverter toHex: viewController.selectedColor];
    
    NSError * error;
    [appDelegate.persistentContainer.viewContext save: &error];
    NSLog (@"colour error is %@", error);
    colourButton.tintColor = viewController.selectedColor;
}

- (IBAction) rename:(id) sender {
    
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
        [((FriendViewController *) self->appDelegate.currentViewController) refresh];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler: nil];

    [alertController addAction: cancelAction];
    [alertController addAction: okAction];
    
    [appDelegate.currentViewController presentViewController: alertController animated: YES completion: nil];
    
    
}

@end
