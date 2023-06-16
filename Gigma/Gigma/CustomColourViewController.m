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
#import "PinIconPickerViewController.h"

@implementation CustomColourViewController

@synthesize markerName;
@synthesize image;
@synthesize locationLatitude;
@synthesize locationLongitude;
@synthesize previousVC;

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    ((AppDelegate *) [[UIApplication sharedApplication] delegate]).currentViewController = self;
}

- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear: animated];
    if (previousVC != nil) {
        [previousVC dismiss];
    }
}

@end
