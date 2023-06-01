//
//  ViewController.m
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import "AddFriendViewController.h"
#import "FriendViewController.h"
#import "NSDictionary+NSDictionaryExtension.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

@synthesize delegate;
@synthesize nicknameTextLabel;
@synthesize deviceIDHash;
@synthesize nearbyDevicePicker;
@synthesize nicknameField;
@synthesize chosenNickname;
@synthesize bluetoothDriver;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bluetoothDriver = [[Bluetoother alloc] init];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    nearbyDevicesMap = [bluetoothDriver nearbyBluetoothDevices];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
    return [nearbyDevicesMap count];
}

- (NSString *) pickerView:(UIPickerView *) pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component {
    return [nearbyDevicesMap objectForKey: [nearbyDevicesMap keyAtIndex: row]];
}

- (IBAction) addButtonPressed:(id) sender {
    NSUUID * chosenDevice = [nearbyDevicesMap keyAtIndex:
                               [nearbyDevicePicker selectedRowInComponent: 0]];
    BOOL didAddSuccessfully = [delegate addFriend: chosenNickname withID: chosenDevice];
    if (didAddSuccessfully) {
        [self dismissViewControllerAnimated: YES completion: nil];
    }
    else {
        nicknameTextLabel.textColor = UIColor.redColor;
        nicknameTextLabel.text = @"Nickname already in use";
    }
}

- (IBAction) nicknameFieldDoneEditing:(id)sender {
    chosenNickname = nicknameField.text;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [self.view endEditing: YES];
    return NO;
}

@end
