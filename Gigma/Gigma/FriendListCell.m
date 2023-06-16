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
@synthesize iconButton;

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

@end
