//
//  ViewController.m
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import "AddFriendViewController.h"
#import "FriendViewController.h"
#import "BluetoothDriver.h"
#import "AppDelegate.h"

@interface AddFriendViewController ()

@property (retain, nonatomic) NSMutableDictionary * nearbyDevicesMap;

@end

@implementation AddFriendViewController

@synthesize delegate;
@synthesize nicknameTextLabel;
@synthesize deviceIDHash;
@synthesize nearbyDevicePicker;
@synthesize nicknameField;
@synthesize chosenNickname;
@synthesize multipeerDriver;
@synthesize nearbyDevicesMap;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    multipeerDriver = appDelegate.bluetoothDriver;
    multipeerDriver.nearbyDevicePickerDelegate = self;
    nearbyDevicesList = [[NSMutableArray alloc] init];
    nearbyDevicesMap = [[NSMutableDictionary alloc] init];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    multipeerDriver.nearbyDevicePickerDelegate = self;
}

- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear: animated];
    multipeerDriver.nearbyDevicePickerDelegate = nil;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
    return [nearbyDevicesList count];
}

- (NSString *) pickerView:(UIPickerView *) pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component {
    MCPeerID * friend = (MCPeerID *) [nearbyDevicesList objectAtIndex: row];
    NSString * fName = friend.displayName;
    return fName;
}

- (IBAction) addButtonPressed:(id) sender {
    // handle this better but this will do for now
    if ([nearbyDevicesList count] == 0) {
        [self dismissViewControllerAnimated: YES completion: nil];
        return;
    }
    
    MCPeerID * chosenDevice = [nearbyDevicesList objectAtIndex:
                               [nearbyDevicePicker selectedRowInComponent: 0]];
    
    if ([chosenNickname length] == 0) {
        nicknameTextLabel.textColor = UIColor.redColor;
        nicknameTextLabel.text = @"Nickname cannot be empty";
    } else if ([delegate nameAlreadyExists: chosenNickname]) {
       nicknameTextLabel.textColor = UIColor.redColor;
       nicknameTextLabel.text = @"Nickname already in use";
    } else {
        [multipeerDriver connectPeer: chosenDevice withOpcode: FRIEND_REQ];
        [self dismissViewControllerAnimated: YES completion: nil];
    }
}

- (IBAction) nicknameFieldDoneEditing:(id) sender {
    chosenNickname = nicknameField.text;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [self.view endEditing: YES];
    return NO;
}

- (void) addNearbyDevice:(MCPeerID *) friend {
    NSLog(@"name of friend: %@", friend.displayName);
    [nearbyDevicesList addObject: friend];
    [nearbyDevicePicker reloadAllComponents];
}

- (void) removeNearbyDevice:(MCPeerID *) friend {
    NSLog(@"name of friend remove: %@", friend.displayName);
    [nearbyDevicesList removeObject: friend];
    [nearbyDevicePicker reloadAllComponents];
}

@end
