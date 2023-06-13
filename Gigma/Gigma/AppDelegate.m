//
//  AppDelegate.m
//  GigmaModel
//
//  Created by Jake Chong on 31/05/2023.
//

#import "AppDelegate.h"
#import "MapSetting+CoreDataProperties.h"
#import <sys/utsname.h>
#import "Gigma-Swift.h"
#import "MultipeerDriver.h"
#import "RSAManager.h"

NSString * deviceName(void) {
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString: systemInfo.machine
                              encoding: NSUTF8StringEncoding];
}

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize data;
@synthesize multipeerDriver;
@synthesize rsaManager;

- (void) checkAndInitialisePrefs:(NSArray *) prefs {
    NSManagedObjectContext * managedObjectContext = self.persistentContainer.viewContext;
    NSEntityDescription * entity = [NSEntityDescription entityForName: @"MapSetting" inManagedObjectContext: managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"prefName" ascending: YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];
    
    NSError * error;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"oops");
    }
    
    
    
    NSMutableArray * innerPrefs = [[NSMutableArray alloc] init];
    for (MapSetting * insidePref in mutableFetchResults) {
        [innerPrefs addObject: insidePref.prefName];
    }
    
    for (NSString * pref in prefs) {
        if (![innerPrefs containsObject: pref]) {
            MapSetting * newPref = [NSEntityDescription insertNewObjectForEntityForName: @"MapSetting" inManagedObjectContext: managedObjectContext];
            newPref.prefName = pref;
            newPref.enabled = NO;
            NSError * error;
            [managedObjectContext save: &error];
        }
    }
}

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    // Override point for customization after application launch.
    data = [[PostgreSQLDriver alloc] init];
    NSArray * prefs = [[NSArray alloc] initWithObjects: @"Show stages", @"Show toilets", @"Show water sources", nil];
    [self checkAndInitialisePrefs: prefs];
    rsaManager = [[RSAManager alloc] init];
    multipeerDriver = [[MultipeerDriver alloc] init];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName: @"Welcome" bundle: nil];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *) application:(UIApplication *) application configurationForConnectingSceneSession:(UISceneSession *) connectingSceneSession options:(UISceneConnectionOptions *) options  API_AVAILABLE(ios(13.0)) {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName: @"Default Configuration" sessionRole: connectingSceneSession.role];
}


- (void) application:(UIApplication *) application didDiscardSceneSessions:(NSSet <UISceneSession *> *) sceneSessions  API_AVAILABLE(ios(13.0)) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *) persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"GigmaModel"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler: ^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void) saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save: &error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
