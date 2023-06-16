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

@interface FriendIconPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    AppDelegate * appDelegate;
    NSArray * icons;
    
}

@property (weak, nonatomic) Friend * currentFriend;
@property (weak, nonatomic) IBOutlet UIPickerView * picker;
@property (weak, nonatomic) NSObject <FriendViewControllerDelegate> * friendDelegate;

- (IBAction) selectIcon: (id) sender;

@end

