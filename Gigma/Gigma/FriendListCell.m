//
//  FriendListCell.m
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import "FriendListCell.h"
#import "ColourConverter.h"

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

@end
