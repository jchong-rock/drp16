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
    NSManagedObjectContext * managedObjectContext;
}

@end

@implementation FriendViewController

@synthesize buttonStack;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // change this to init instead of initWithObjects
    
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    managedObjectContext = appDelegate.persistentContainer.viewContext;
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    NSEntityDescription * entity = [NSEntityDescription entityForName: @"Friend" inManagedObjectContext: managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendName" ascending: YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];
    
    NSError * error;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Failed to load Friends list");
    }
    friendButtonList = mutableFetchResults;
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    id destination = [segue destinationViewController];
    if ([destination isKindOfClass: [AddFriendViewController class]]) {
        ((AddFriendViewController *) destination).delegate = self;
    }
}

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return YES;
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"%@, %ld", ((Friend *)[friendButtonList objectAtIndex: indexPath.row]).friendName, (long) indexPath.row);
        
        [managedObjectContext deleteObject: [friendButtonList objectAtIndex: indexPath.row]];
        [friendButtonList removeObjectAtIndex: indexPath.row];
        [buttonStack reloadData];
        NSError * error;
        [managedObjectContext save: &error];
    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"FriendCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"FriendCellIdentifier"];
    }
    
    Friend * friend = [friendButtonList objectAtIndex: indexPath.row];
    cell.textLabel.text = friend.friendName;
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [friendButtonList count];
}

- (BOOL) addFriend:(NSString *) name withID:(NSString *) uid {
    for (Friend * f in friendButtonList) {
        if (f.friendName == name) {
            return NO;
        }
    }
    
    if (name != nil) {
        Friend * friend = [NSEntityDescription insertNewObjectForEntityForName: @"Friend" inManagedObjectContext:managedObjectContext];
        friend.friendName = name;
        friend.deviceID = uid;
        [friendButtonList addObject: friend];
        [buttonStack reloadData];
        NSError * error;
        [managedObjectContext save: &error];
        return YES;
    }
    return NO;
}


@end

