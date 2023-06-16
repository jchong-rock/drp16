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
}

- (IBAction) selectIcon:(id) sender {
    NSString * pickedIcon = [icons objectAtIndex: [picker selectedRowInComponent: 0]];
//    UIButton * selectButton
    currentFriend.icon = pickedIcon;
    
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
