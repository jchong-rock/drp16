//
//  FestivalSettingsViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "FestivalSettingsViewController.h"
#import "Gigma-Swift.h"
#import "AppDelegate.h"
#import "RSAManager.h"

@interface FestivalSettingsViewController () {
    NSUserDefaults * prefs;
    AppDelegate * appDelegate;
}

@end

@implementation FestivalSettingsViewController

@synthesize displayName;

- (void) viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    NSString * savedName = appDelegate.rsaManager.name;
    if (savedName != nil) {
        displayName.text = [@"Display name: " stringByAppendingString: savedName];
    } else {
        displayName.text = @"Display name not set";
    }
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    appDelegate.currentViewController = self;
}

- (IBAction) leaveButtonPressed:(id) sender {
    [prefs setObject: nil forKey: @"FestivalIsSet"];
    [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName: @"clear-cache" object: nil]];
    [self performSegueWithIdentifier: @"goToWelcome" sender: self];
}

@end
