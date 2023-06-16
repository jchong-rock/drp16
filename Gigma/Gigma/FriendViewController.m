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
#import "MultipeerDriver.h"
#import "ColourConverter.h"
#import "RSAManager.h"
#import "Gigma-Swift.h"
#import "FriendIconPickerViewController.h"

@interface FriendViewController () {
    NSManagedObjectContext * managedObjectContext;
    AppDelegate * appDelegate;
}

@property (weak, nonatomic) MultipeerDriver * multipeerDriver;

@end

@implementation FriendViewController

@synthesize buttonStack;
@synthesize discoverableButton;
@synthesize multipeerDriver;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    discoverableButton.tintColor = [UIColor systemBlueColor];
    discoverableButton.tintColor = [UIColor systemRedColor];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    multipeerDriver = appDelegate.multipeerDriver;
    multipeerDriver.friendViewControllerDelegate = self;
    NSLog(@"my public key: %@" , appDelegate.rsaManager.publicKey);
    managedObjectContext = appDelegate.persistentContainer.viewContext;
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    friendButtonList = [MainViewController getFriendsFromContext: managedObjectContext];
    if (friendButtonList == nil) {
        [MainViewController showErrorPopup: self withMessage: @"Failed to load friends list"];
    }
}

- (void) refresh {
    [buttonStack reloadData];
    NSError * error;
    [managedObjectContext save: &error];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    appDelegate.currentViewController = self;
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
    if ([segue.identifier isEqualToString: @"goToMapFL"]) {
        FriendListCell * selectedCell = (FriendListCell *) ((UIButton *) sender).superview.superview;
        MapViewController * destinationVC = segue.destinationViewController;
        destinationVC.currentFriend = selectedCell.friend;
    }
    
    if ([segue.identifier isEqualToString: @"goToFriendIconPicker"]) {
        FriendListCell * selectedCell = (FriendListCell *) ((UIButton *) sender).superview.superview;
        FriendIconPickerViewController * destinationVC = segue.destinationViewController;
        destinationVC.currentFriend = selectedCell.friend;
        destinationVC.friendDelegate = self;
    }
}

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return YES;
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Friend * friend = [friendButtonList objectAtIndex: indexPath.row];
        [multipeerDriver sendUnfriendRequest: friend];
        [managedObjectContext deleteObject: friend];
        [self deleteFriend: friend];
        NSError * error;
        [managedObjectContext save: &error];
    }
}

- (void) deleteFriend:(Friend *) friend {
    [friendButtonList removeObject: friend];
    [buttonStack reloadData];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    FriendListCell * cell = [tableView dequeueReusableCellWithIdentifier: @"FriendCellIdentifier"];
    if (cell == nil) {
        cell = [[FriendListCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"FriendCellIdentifier"];
    }
    
    Friend * friend = [friendButtonList objectAtIndex: indexPath.row];
    cell.friend = friend;
    [cell.iconButton setImage: [UIImage systemImageNamed: friend.icon] forState: UIControlStateNormal];
    [cell.colourButton setTintColor: [ColourConverter toColour: friend.colour]];
    [cell.messageButton setTitle: @"" forState: UIControlStateNormal];
    [cell.locationButton setTitle: @"" forState: UIControlStateNormal];
    [cell.colourButton setTitle: @"" forState: UIControlStateNormal];
    [cell.iconButton setTitle: @"" forState: UIControlStateNormal];
    cell.textLabel.text = friend.friendName;
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [friendButtonList count];
}

- (BOOL) nameAlreadyExists:(NSString *) name {
    for (Friend * f in friendButtonList) {
        if (f.friendName == name) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) addFriend:(MCPeerID *) name withPubKey:(NSString *) pubKey {
    NSLog(@"friend public key: %@" , pubKey);
    if (name != nil) {
        Friend * friend = [NSEntityDescription insertNewObjectForEntityForName: @"Friend" inManagedObjectContext: managedObjectContext];
        friend.friendName = name.displayName;
        friend.deviceID = pubKey;
        friend.peerID = name.hash;
        friend.colour = [ColourConverter toHex: UIColor.systemPinkColor];
        friend.icon = [FriendIcons getDefault];
        [friendButtonList addObject: friend];
        [buttonStack reloadData];
        NSError * error;
        [managedObjectContext save: &error];
        return YES;
    }
    return NO;
}

- (IBAction) discoverablePressed:(id) sender {
    discoverableButton.tintColor = [UIColor systemBlueColor];
    [multipeerDriver stopAdvertising];
    [NSTimer scheduledTimerWithTimeInterval: 1.0f
                                     target: self
                                   selector: @selector(discoverMiddle)
                                   userInfo: nil
                                    repeats: NO];
}

- (void) discoverMiddle {
    [multipeerDriver startAdvertising];
    [NSTimer scheduledTimerWithTimeInterval: 5.0f
                                     target: self
                                   selector: @selector(discoverEnd)
                                   userInfo: nil
                                    repeats: NO];
}

- (void) discoverEnd {
    discoverableButton.tintColor = [UIColor systemRedColor];
}

- (IBAction) colourSelector:(id) sender {
    UIButton * button = (UIButton *) sender;
    //button.tintColor = //TODO: pull from core data
    UIColorPickerViewController * colourPicker = [[UIColorPickerViewController alloc] init];
    colourPicker.delegate = (FriendListCell *) button.superview.superview;
    [self presentViewController: colourPicker animated: YES completion: nil];
}

- (IBAction) iconSelector:(id) sender {
    [self performSegueWithIdentifier:@"goToFriendIconPicker" sender: sender];
}


- (void) showPopup:(UIViewController *) popup withCompletion:(id) completion {
    [self presentViewController: popup animated: YES completion: completion];
}

@end

