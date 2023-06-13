//
//  ViewController.h
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FriendViewController.h"
#import "BluetoothDriver.h"

@interface AddFriendViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, NearbyDevicePickerDelegate> {
        NSMutableArray <Friend *> * nearbyDevicesList;
        IBOutlet UIPickerView * nearbyDevicePicker;
        IBOutlet UITextField * nicknameField;
        IBOutlet UILabel * nicknameTextLabel;
}

@property (assign, nonatomic) id <FriendViewControllerDelegate> delegate;
@property (retain, nonatomic) UITextField * nicknameField;
@property (retain, nonatomic) UILabel * nicknameTextLabel;
@property (retain, nonatomic) UIPickerView * nearbyDevicePicker;
@property (retain, nonatomic) NSString * deviceIDHash;
@property (retain, nonatomic) NSString * chosenNickname;
@property (retain, nonatomic) BluetoothDriver * bluetoothDriver;


- (IBAction) addButtonPressed:(id) sender;
- (IBAction) nicknameFieldDoneEditing:(id) sender;

@end

