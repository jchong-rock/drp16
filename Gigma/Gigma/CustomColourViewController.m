//
//  UIApplication+CurrentViewController.h
//  Gigma
//
//  Created by Jake Chong on 15/06/2023.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomColourViewController.h"
#import "AppDelegate.h"

@implementation CustomColourViewController

@synthesize markerName;
@synthesize locationLatitude;
@synthesize locationLongitude;

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).currentViewController = self;
}

@end
