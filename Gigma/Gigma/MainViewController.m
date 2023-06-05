//
//  MainViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "MainViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

+ (void) showErrorPopup:(UIViewController *) vc withMessage:(NSString *) msg {
    UIAlertController * popup = [UIAlertController alertControllerWithTitle: @"Error" message: msg preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction * ok = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {}];
    
    [popup addAction: ok];
    [vc presentViewController: popup animated: YES completion: nil];
}

+ (NSArray *) prefsList:(UIViewController *) vc {
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * managedObjectContext = appDelegate.persistentContainer.viewContext;
    NSEntityDescription * entity = [NSEntityDescription entityForName: @"MapSetting" inManagedObjectContext: managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"prefName" ascending: YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];

    NSError * error;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    if (mutableFetchResults == nil) {
        [MainViewController showErrorPopup: vc withMessage: @"Failed to load preferences list"];
    }
    return mutableFetchResults;
}

+ (NSMutableArray *) getFriendsFromContext:(NSManagedObjectContext *) managedObjectContext {
    NSEntityDescription * entity = [NSEntityDescription entityForName: @"Friend" inManagedObjectContext: managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"friendName" ascending: YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];
    
    NSError * error;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    return mutableFetchResults;
}

@end
