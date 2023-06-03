//
//  MapSettings.h
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import <UIKit/UIKit.h>

@interface MapSettingsViewController : UIViewController {
    IBOutlet UITableView * settingStack;
}

@property (retain, nonatomic) UITableView * settingStack;
@property (retain, nonatomic) NSArray * prefButtonList;

- (IBAction) changePrefValue:(id) sender;

@end
