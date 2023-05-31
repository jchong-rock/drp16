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

- (void) viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger festivalIsSet = [prefs integerForKey: @"FestivalIsSet"];
    if (festivalIsSet == 1) {
        [self performSegueWithIdentifier: @"goToMain" sender: self];
    }
}

- (IBAction) continueButtonPressed:(id) sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger: 1 forKey: @"FestivalIsSet"];
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

/*
- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if (segue.identifier == @"goToMain") {
        
    }
}
 */

@end
