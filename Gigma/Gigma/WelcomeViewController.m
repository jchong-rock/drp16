//
//  MainViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * festivalIsSet = [prefs stringForKey: @"FestivalIsSet"];
    if (festivalIsSet != nil) {
        [self performSegueWithIdentifier: @"goToMain" sender: self];
    }
}

- (IBAction) continueButtonPressed:(id) sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: @"FEST_NAME" forKey: @"FestivalIsSet"];
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

- (IBAction) notListedButtonPressed:(id) sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: @"NULL_FESTIVAL" forKey: @"FestivalIsSet"];
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

@end
