//
//  MainViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "MainViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CustomMarker+CoreDataProperties.h"
#import "Friend+CoreDataProperties.h"
#import <NSDate_Utils/NSDate+NSDate_Util.h>

@interface MainViewController ()

@end

@implementation MainViewController

+ (CLLocationCoordinate2D) getFriendLocation:(Friend *) friend {
    return CLLocationCoordinate2DMake(friend.latitude, friend.longitude);
}

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
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"peerID" ascending: YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];
    
    NSError * error;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    return mutableFetchResults;
}

+ (NSString *) stringFromDate:(NSDate *) date {
    return [NSDate stringForDisplayFromDate: date];
}

+ (NSMutableArray *) getParagraphsFromContext:(NSManagedObjectContext *) managedObjectContext {
    NSEntityDescription * entity = [NSEntityDescription entityForName: @"Paragraph" inManagedObjectContext: managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"heading" ascending: YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];
    
    NSError * error;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    return mutableFetchResults;
}

+ (NSMutableArray *) getCustomMarkersFromContext:(NSManagedObjectContext *) managedObjectContext {
    NSEntityDescription * entity = [NSEntityDescription entityForName: @"CustomMarker" inManagedObjectContext: managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];
    
    NSError * error;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    return mutableFetchResults;
}


@end
