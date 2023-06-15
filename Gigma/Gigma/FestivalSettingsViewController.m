//
//  FestivalSettingsViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "FestivalSettingsViewController.h"
#import "Gigma-Swift.h"

@interface FestivalSettingsViewController () {
    NSUserDefaults * prefs;
}

@end

@implementation FestivalSettingsViewController

@synthesize displayName;

- (void) viewDidLoad {
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    NSString * savedName = [prefs objectForKey: @"RSAName"];
    if (savedName != nil) {
        displayName.text = [@"Display name: " stringByAppendingString: savedName];
    } else {
        displayName.text = @"Display name not set";
    }
}

- (IBAction) leaveButtonPressed:(id) sender {
    [prefs setObject: nil forKey: @"FestivalIsSet"];
    [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName: @"clear-cache" object: nil]];
    [self performSegueWithIdentifier: @"goToWelcome" sender: self];
}

@end
