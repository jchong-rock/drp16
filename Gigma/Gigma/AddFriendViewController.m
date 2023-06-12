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
@synthesize bluetoothDriver;
@synthesize nearbyDevicesMap;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    bluetoothDriver = appDelegate.bluetoothDriver;
    bluetoothDriver.nearbyDevicePickerDelegate = self;
    nearbyDevicesList = [[NSMutableArray alloc] init];
    nearbyDevicesMap = [[NSMutableDictionary alloc] init];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    bluetoothDriver.nearbyDevicePickerDelegate = self;
}

- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear: animated];
    bluetoothDriver.nearbyDevicePickerDelegate = nil;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
    return [nearbyDevicesList count];
}

- (NSString *) pickerView:(UIPickerView *) pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component {
    NSString * friend = (NSString *) [nearbyDevicesList objectAtIndex: row];
    NSString * fName = [nearbyDevicesMap objectForKey: friend];
    return fName;
}

- (IBAction) addButtonPressed:(id) sender {
    // handle this better but this will do for now
    if ([nearbyDevicesList count] == 0) {
        [self dismissViewControllerAnimated: YES completion: nil];
        return;
    }
    
    NSString * chosenDevice = [nearbyDevicesList objectAtIndex:
                               [nearbyDevicePicker selectedRowInComponent: 0]];
    
    if ([chosenNickname length] == 0) {
        nicknameTextLabel.textColor = UIColor.redColor;
        nicknameTextLabel.text = @"Nickname cannot be empty";
    } else if ([delegate nameAlreadyExists: chosenNickname]) {
       nicknameTextLabel.textColor = UIColor.redColor;
       nicknameTextLabel.text = @"Nickname already in use";
    }
    
    // Set the timeout interval
    double timeoutInSeconds = 15.0;
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutInSeconds * NSEC_PER_SEC));
    
    // Wait for the semaphore to be signaled or timeout
    
    [bluetoothDriver usePeripheral];
    long result = dispatch_semaphore_wait(bluetoothDriver.acceptFriendSemaphore, timeout);
    [bluetoothDriver useCentral];
    
    if (result == 0) {
        NSLog(@"Completion handler has been called.");
        if (delegate != nil) {
            BOOL didAddSuccessfully = [delegate addFriend: chosenNickname withPubKey: chosenDevice];
            if (didAddSuccessfully) {
                [self dismissViewControllerAnimated: YES completion: nil];
            }
        }
    } else {
        NSLog(@"Timeout occurred.");
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

- (void) addNearbyDevice:(NSString *) friend withPubKey:(NSString * _Nullable) pubKey {
    NSLog(@"name of friend: %@", friend);
    if ([nearbyDevicesMap objectForKey: pubKey] == nil) {
        [nearbyDevicesList addObject: pubKey];
    }
    [nearbyDevicesMap setObject: friend forKey: pubKey];
    [nearbyDevicePicker reloadAllComponents];
}

@end
