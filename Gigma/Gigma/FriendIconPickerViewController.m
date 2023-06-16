//
//  FriendIconPickerViewController.m
//  Gigma
//
//  Created by kup21 on 16/06/2023.
//

#import <Foundation/Foundation.h>
#import "FriendIconPickerViewController.h"
#import "Gigma-Swift.h"


@implementation FriendIconPickerViewController 

@synthesize currentFriend;
@synthesize picker;
@synthesize displayName;
@synthesize friendDelegate;

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
    [displayName setPlaceholder: currentFriend.friendName];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction) selectIcon:(id) sender {
    NSString * pickedIcon = [icons objectAtIndex: [picker selectedRowInComponent: 0]];
    currentFriend.icon = pickedIcon;
    if ([displayName.text length] > 0) {
        self.currentFriend.friendName = displayName.text;
    }
    
    NSError * error;
    [appDelegate.persistentContainer.viewContext save: &error];
    [friendDelegate refresh];
    
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (NSInteger) numberOfComponentsInPickerView:(nonnull UIPickerView *) pickerView {
    return 1;
}

- (NSInteger) pickerView:(nonnull UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
    return [icons count];
}

- (NSString *) pickerView:(UIPickerView *) pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component {
    return icons[row];
}



@end
