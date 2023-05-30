//
//  ViewController.h
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import <UIKit/UIKit.h>
#import "FriendViewController.h"

@interface AddFriendViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
        NSMutableArray * nearbyDevicesList;
        IBOutlet UIPickerView * nearbyDevicePicker;
        IBOutlet UITextField * nicknameField;
}

@property (retain, nonatomic) UITextField * nicknameField;
@property (retain, nonatomic) UIPickerView * nearbyDevicePicker;
@property (retain, nonatomic) NSString * deviceIDHash;
@property (retain, nonatomic) NSString * chosenNickname;


- (IBAction) addButtonPressed:(id) sender;
- (IBAction) nicknameFieldDoneEditing:(id) sender;

@end

