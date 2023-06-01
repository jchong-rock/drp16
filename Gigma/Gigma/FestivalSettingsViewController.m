//
//  FestivalSettingsViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "FestivalSettingsViewController.h"
#import "Gigma-Swift.h"

@interface FestivalSettingsViewController ()

@end

@implementation FestivalSettingsViewController

- (IBAction) leaveButtonPressed:(id) sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: nil forKey: @"FestivalIsSet"];
    [[NSNotificationCenter defaultCenter] postNotification: [NSNotification notificationWithName: @"clear-cache" object: nil]];
    [self performSegueWithIdentifier: @"goToWelcome" sender: self];
}

@end
