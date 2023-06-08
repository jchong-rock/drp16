//
//  MainViewController.h
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>
#define PUB_KEY_SIZE 2048

@interface MainViewController : UITabBarController

+ (void) showErrorPopup:(UIViewController *) vc withMessage:(NSString *) msg;
+ (NSArray *) prefsList:(UIViewController *) vc;
+ (NSMutableArray *) getFriendsFromContext:(NSManagedObjectContext *) managedObjectContext;

@end
