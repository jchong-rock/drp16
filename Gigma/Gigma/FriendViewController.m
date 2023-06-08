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
#import "BluetoothDriver.h"

@interface FriendViewController () {
    NSManagedObjectContext * managedObjectContext;
    BluetoothDriver * btDriver;
}

@property (weak, nonatomic) UIColor * friendColour;

@end

@implementation FriendViewController

@synthesize buttonStack;
@synthesize discoverableButton;

@synthesize friendColour;

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
    [NSTimer scheduledTimerWithTimeInterval: 6.0f
                                     target: self
                                   selector: @selector(discoverEnd)
                                   userInfo: nil
                                    repeats: NO];
}

- (void) discoverEnd {
    [btDriver useCentral];
    discoverableButton.tintColor = [UIColor systemRedColor];
}

- (BOOL) addFriend:(Friend *) friend {
    for (Friend * f in friendButtonList) {
        if (f.friendName == friend.friendName) {
            return NO;
        }
    }
    
    if (friend.friendName != nil) {
        Friend * friend2 = [NSEntityDescription insertNewObjectForEntityForName: @"Friend" inManagedObjectContext: managedObjectContext];
        friend2.friendName = friend.friendName;
        friend2.deviceID = friend.deviceID;
        [friendButtonList addObject: friend2];
        [buttonStack reloadData];
        NSError * error;
        [managedObjectContext save: &error];
        return YES;
    }
    return NO;
}

- (void)setColour:(UIColor *)colour {
    friendColour = colour;
}


- (IBAction) colourSelector:(id) sender {
    UIButton * button = (UIButton *) sender;
    //button.tintColor = //pull from core data
    UIColorPickerViewController * picker = [[UIColorPickerViewController alloc] init];
    picker.delegate = (FriendListCell *) button.superview.superview;
    [self presentViewController: picker animated: YES completion: nil];
    
}

@end

