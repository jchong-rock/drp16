//
//  FriendIconPickerViewController.m
//  Gigma
//
//  Created by kup21 on 16/06/2023.
//

#import <Foundation/Foundation.h>
#import "PinIconPickerViewController.h"
#import "Gigma-Swift.h"


@implementation PinIconPickerViewController

@synthesize picker;
@synthesize displayName;
@synthesize colourDelegate;
@synthesize latitude;
@synthesize longitude;

- (void) viewDidLoad {
    [super viewDidLoad];
    picker.delegate = self;
    icons = [FriendIcons getAllList];
    //[[NSArray alloc] initWithArray: [FriendIcons getAllList]];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
}
- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    appDelegate.currentViewController = self;
    displayName.delegate = self;
    [displayName setPlaceholder: @"Pin name"];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction) selectIcon:(id) sender {
    NSString * pickedIcon = [icons objectAtIndex: [picker selectedRowInComponent: 0]];
    CustomColourViewController * colourPicker = [[CustomColourViewController alloc] init];
    colourPicker.delegate = colourDelegate;
    colourPicker.locationLatitude = [NSNumber numberWithDouble: latitude];
    colourPicker.locationLongitude = [NSNumber numberWithDouble: longitude];
    colourPicker.image = pickedIcon;
    if ([displayName.text length] > 0) {
        colourPicker.markerName = displayName.text;
    }
    colourPicker.previousVC = self;
    
    [self presentViewController: colourPicker animated: YES completion: nil];
}

- (NSInteger) numberOfComponentsInPickerView:(nonnull UIPickerView *) pickerView {
    return 1;
}

- (void) dismiss {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (NSInteger) pickerView:(nonnull UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
    return [icons count];
}

- (NSAttributedString *) pickerView:(UIPickerView *) pickerView attributedTitleForRow:(NSInteger) row forComponent:(NSInteger) component {
    NSString * symbolName = icons[row];
    UIImage * symbolImage = [[UIImage systemImageNamed: symbolName] imageWithTintColor: UIColor.labelColor];
    
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    attachment.image = symbolImage;
    
    NSAttributedString * attributedString = [NSAttributedString attributedStringWithAttachment: attachment];
    
    return attributedString;
}



@end
