//
//  ViewController.h
//  Gigma
//
//  Created by Jake Chong on 29/05/2023.
//

#import <UIKit/UIKit.h>

@interface AddFriendViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray * nearbyDevicesList;
}

@property (retain, nonatomic) NSString * deviceIDHash;

- (IBAction) pickerValueChanged:(id) sender;

@end

