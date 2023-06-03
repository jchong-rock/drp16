//
//  MapSettings.h
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import <UIKit/UIKit.h>

@protocol PopoverDelegate <NSObject>

- (void) popoverDidDisappear;

@end

@interface MapSettingsViewController : UIViewController {
    IBOutlet UITableView * settingStack;
}

@property (retain, nonatomic) UITableView * settingStack;
@property (retain, nonatomic) NSArray * prefButtonList;
@property (nonatomic, weak) id <PopoverDelegate> delegate;

- (IBAction) changePrefValue:(id) sender;
- (IBAction) saveButtonPressed:(id) sender;

@end
