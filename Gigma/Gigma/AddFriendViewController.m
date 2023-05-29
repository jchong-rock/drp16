//
//  ViewController.m
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

@synthesize deviceIDHash;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // NSLog(@"here");
    nearbyDevicesList = [[NSArray alloc] initWithObjects:@"friend1", @"friend2", nil];
}

- (IBAction) pickerValueChanged:(id) sender {
    
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

- (void) dealloc {
    [nearbyDevicesList release];
    [super dealloc];
}

@end
