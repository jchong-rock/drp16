//
//  FriendViewController.m
//  Gigma
//
//  Created by Jake Chong on 30/05/2023.
//

#import "FriendViewController.h"
#import "AddFriendViewController.h"
#import "Friend+CoreDataProperties.h"
#import "AppDelegate.h"
#import "Friend+CoreDataProperties.h"

@interface FriendViewController () {
    NSString * pathToFriendsList;
}

@end

@implementation FriendViewController

@synthesize buttonStack;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // change this to init instead of initWithObjects
    pathToFriendsList = [[NSBundle mainBundle] pathForResource: @"FriendsList" ofType: @"plist"];
    friendButtonList = [[NSMutableArray alloc] init];
    friends = [[NSMutableDictionary alloc] initWithContentsOfFile: pathToFriendsList];
    for (id key in friends) {
        [friendButtonList addObject: key];
    }
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: <#animated#>];
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * managedObjectContext = appDelegate.managedObjectContext;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    id destination = [segue destinationViewController];
    if ([destination isKindOfClass: [AddFriendViewController class]]) {
        ((AddFriendViewController *) destination).delegate = self;
    }
    [friends writeToFile: pathToFriendsList atomically: YES];
    NSLog(@"written");
}

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return YES;
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id keyToRemove = [friendButtonList objectAtIndex: indexPath.row];
        [friends removeObjectForKey: keyToRemove];
        [friendButtonList removeObjectAtIndex: indexPath.row];
        [buttonStack reloadData];
    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    
    //static NSString * CellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"FriendCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"FriendCellIdentifier"];
    }
    cell.textLabel.text = [friendButtonList objectAtIndex: indexPath.row];
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [friendButtonList count];
}

- (BOOL) addFriend:(NSString *) name withID:(NSString *) uid {
    if (name != nil && [friends objectForKey: name] == nil) {
        [friends setObject: uid forKey: name];
        [friendButtonList addObject: name];
        [buttonStack reloadData];
        return YES;
    }
    return NO;
}


@end

