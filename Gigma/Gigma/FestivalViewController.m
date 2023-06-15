//
//  FestivalViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "FestivalViewController.h"
#import "AppDelegate.h"

@interface FestivalViewController () {
    AppDelegate * appDelegate;
}

@end

@implementation FestivalViewController

@synthesize titleLabel;
@synthesize settingsButton;

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [settingsButton setTitle: @"" forState: UIControlStateNormal];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    appDelegate.currentViewController = self;
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSString * festivalIsSet = [prefs stringForKey: @"FestivalIsSet"];
    if (festivalIsSet != nil) {
        titleLabel.text = festivalIsSet;
    }
}

@end
