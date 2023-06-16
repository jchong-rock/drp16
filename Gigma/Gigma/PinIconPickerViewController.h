//
//  Header.h
//  Gigma
//
//  Created by kup21 on 16/06/2023.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Friend+CoreDataProperties.h"
#import "FriendViewController.h"

@protocol PinDismisser <NSObject>

- (void) dismiss;

@end

@interface PinIconPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, PinDismisser> {
    AppDelegate * appDelegate;
    NSArray * icons;
    
}

@property double latitude;
@property double longitude;
@property (weak, nonatomic) IBOutlet UIPickerView * picker;
@property (weak, nonatomic) IBOutlet UITextField * displayName;
@property (weak, nonatomic) NSObject <UIColorPickerViewControllerDelegate> * colourDelegate;

- (IBAction) selectIcon: (id) sender;

@end

