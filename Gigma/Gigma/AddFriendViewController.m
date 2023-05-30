//
//  ViewController.m
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import "AddFriendViewController.h"
#import "FriendViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

@synthesize deviceIDHash;
@synthesize nearbyDevicePicker;
@synthesize nicknameField;
@synthesize chosenNickname;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nearbyDevicesList = [[NSMutableArray alloc] initWithObjects:@"device1", @"device2", nil];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
    return [nearbyDevicesList count];
}

- (NSString *) pickerView:(UIPickerView *) pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component {
    return [nearbyDevicesList objectAtIndex: row];
}

- (IBAction) addButtonPressed:(id) sender {
    NSString * chosenDevice = [nearbyDevicesList objectAtIndex:
                               [nearbyDevicePicker selectedRowInComponent: 0]];
    BOOL didAddSuccessfully = YES; // call method "addFriend" in FriendViewController
    NSLog(@"you chose %@ and typed %@", chosenDevice, chosenNickname);
}

- (IBAction) nicknameFieldDoneEditing:(id)sender {
    chosenNickname = nicknameField.text;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [self.view endEditing: YES];
    return NO;
}

- (void) dealloc {
    [chosenNickname release];
    [nicknameField release];
    [deviceIDHash release];
    [nearbyDevicePicker release];
    [nearbyDevicesList release];
    [super dealloc];
}

@end
