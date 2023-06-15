//
//  FestivalViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "FestivalViewController.h"
#import "AppDelegate.h"
#import "Gigma-Swift.h"

@interface FestivalViewController () {
    AppDelegate * appDelegate;
    NSUserDefaults * prefs;
    NSString * dummyString; // replace with real string
}

@end

@implementation FestivalViewController

@synthesize titleLabel;
@synthesize settingsButton;

- (void) viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    [settingsButton setTitle: @"" forState: UIControlStateNormal];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    appDelegate.currentViewController = self;
    NSString * festivalIsSet = [prefs stringForKey: @"FestivalIsSet"];
    if (festivalIsSet != nil) {
        titleLabel.text = festivalIsSet;
    }
}

- (void) getFestivalInfo {
    NSString * description = [prefs stringForKey: @"FestivalDescription"];
    if (description != nil) {
        dummyString = description; // REPLACE
    } else {
        NSObject <DataBaseDriver> * databaseDriver = appDelegate.data;
        NSInteger festivalID = [prefs integerForKey: @"FestivalIDSet"];
        NSString * foundDescription = [databaseDriver getInfoWithFestivalID: festivalID];
        
    }
}

@end
