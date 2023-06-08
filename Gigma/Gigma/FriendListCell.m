//
//  FriendListCell.m
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import "FriendListCell.h"

@implementation FriendListCell

@synthesize friend;
@synthesize colourButton;
@synthesize delegate;

- (void) colorPickerViewControllerDidFinish:(UIColorPickerViewController *) viewController {
    [delegate setColour: viewController.selectedColor];
    colourButton.tintColor = viewController.selectedColor;
}

@end
