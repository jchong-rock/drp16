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
#import "MainViewController.h"
#import "ComposeMessageViewController.h"
#import "FriendListCell.h"

@interface FriendViewController () {
    NSManagedObjectContext * managedObjectContext;
    NSObject <BluetoothDriver> * btDriver;
}

@end

@implementation FriendViewController

@synthesize buttonStack;
@synthesize discoverableButton;

- (void) viewDidLoad {
    [super viewDidLoad];
    discoverableButton.tintColor = [UIColor systemBlueColor];
    discoverableButton.tintColor = [UIColor systemRedColor];
    // Do any additional setup after loading the view.
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    btDriver = appDelegate.bluetoothDriver;
    managedObjectContext = appDelegate.persistentContainer.viewContext;
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    friendButtonList = [MainViewController getFriendsFromContext: managedObjectContext];
    if (friendButtonList == nil) {
        [MainViewController showErrorPopup: self withMessage: @"Failed to load friends list"];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    id destination = [segue destinationViewController];
    if ([destination isKindOfClass: [AddFriendViewController class]]) {
        ((AddFriendViewController *) destination).delegate = self;
    }
    if ([segue.identifier isEqualToString: @"goToMessagesFL"]) {
        FriendListCell * selectedCell = (FriendListCell *) ((UIButton *) sender).superview.superview;
        ComposeMessageViewController * destinationVC = segue.destinationViewController;
        destinationVC.recipient = selectedCell.friend;
    }
}

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return YES;
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [managedObjectContext deleteObject: [friendButtonList objectAtIndex: indexPath.row]];
        [friendButtonList removeObjectAtIndex: indexPath.row];
        [buttonStack reloadData];
        NSError * error;
        [managedObjectContext save: &error];
    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    FriendListCell * cell = [tableView dequeueReusableCellWithIdentifier: @"FriendCellIdentifier"];
    if (cell == nil) {
        cell = [[FriendListCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"FriendCellIdentifier"];
    }
    
    Friend * friend = [friendButtonList objectAtIndex: indexPath.row];
    cell.friend = friend;
    cell.textLabel.text = friend.friendName;
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [friendButtonList count];
}

- (IBAction) discoverablePressed:(id) sender {
    discoverableButton.tintColor = [UIColor systemBlueColor];
    [btDriver usePeripheral];
    [btDriver broadcastName];
    [NSTimer scheduledTimerWithTimeInterval: 2.0f
                                     target: self
                                   selector: @selector(discoverEnd)
                                   userInfo: nil
                                    repeats: NO];
}

- (void) discoverEnd {
    [btDriver useCentral];
    discoverableButton.tintColor = [UIColor systemRedColor];
}

- (BOOL) addFriend:(NSString *) name withID:(NSUUID *) uid {
    for (Friend * f in friendButtonList) {
        if (f.friendName == name) {
            return NO;
        }
    }
    
    if (name != nil) {
        Friend * friend = [NSEntityDescription insertNewObjectForEntityForName: @"Friend" inManagedObjectContext: managedObjectContext];
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

