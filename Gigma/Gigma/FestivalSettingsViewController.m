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

@synthesize textField;

- (void) viewDidLoad {
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    textField.text = [prefs objectForKey: @"RSAName"];
}

- (IBAction) displayNameDidChangeValue:(id) sender {
    [prefs setObject: textField.text forKey: @"RSAName"];
}

- (IBAction) leaveButtonPressed:(id) sender {
    [prefs setObject: nil forKey: @"FestivalIsSet"];
    [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName: @"clear-cache" object: nil]];
    [self performSegueWithIdentifier: @"goToWelcome" sender: self];
}

@end
