//
//  MainViewController.h
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class Friend;

@interface MainViewController : UITabBarController

+ (CLLocationCoordinate2D) getFriendLocation:(Friend *) friend;
+ (void) showErrorPopup:(UIViewController *) vc withMessage:(NSString *) msg;
+ (NSArray *) prefsList:(UIViewController *) vc;
+ (NSMutableArray *) getFriendsFromContext:(NSManagedObjectContext *) managedObjectContext;
+ (NSMutableArray *) getCustomMarkersFromContext:(NSManagedObjectContext *) managedObjectContext;


@end
