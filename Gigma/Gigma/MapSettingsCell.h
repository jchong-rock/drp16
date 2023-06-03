//
//  MapSettings.h
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import <UIKit/UIKit.h>
#import "MapSetting+CoreDataProperties.h"

@interface MapSettingsCell : UITableViewCell {
    IBOutlet UISwitch * toggle;
}

@property (retain, nonatomic) MapSetting * pref;
@property (retain, nonatomic) UISwitch * toggle;

@end
