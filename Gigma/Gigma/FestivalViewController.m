//
//  FestivalViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "FestivalViewController.h"

@interface FestivalViewController ()

@end

@implementation FestivalViewController

@synthesize titleLabel;

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * festivalIsSet = [prefs stringForKey: @"FestivalIsSet"];
    if (festivalIsSet != nil) {
        titleLabel.text = festivalIsSet;
    }
}

@end
