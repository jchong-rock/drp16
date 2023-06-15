//
//  MainViewController.h
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController

+ (void) showErrorPopup:(UIViewController *) vc withMessage:(NSString *) msg;
+ (NSArray *) prefsList:(UIViewController *) vc;
+ (NSMutableArray *) getFriendsFromContext:(NSManagedObjectContext *) managedObjectContext;
+ (NSMutableArray *) getCustomMarkersFromContext:(NSManagedObjectContext *) managedObjectContext;


@end
