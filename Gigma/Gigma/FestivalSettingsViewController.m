//
//  FestivalSettingsViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "FestivalSettingsViewController.h"

@interface FestivalSettingsViewController ()

@end

@implementation FestivalSettingsViewController

- (IBAction) leaveButtonPressed:(id) sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: nil forKey: @"FestivalIsSet"];
    [self performSegueWithIdentifier: @"goToWelcome" sender: self];
}

@end
