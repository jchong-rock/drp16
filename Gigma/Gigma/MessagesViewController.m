//
//  MessagesViewController.m
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import "MessagesViewController.h"
#import "Message+CoreDataProperties.h"
#import "Friend+CoreDataProperties.h"
#import "MessageSelectionCell.h"
#import <NSDate_Utils/NSDate+NSDate_Util.h>
#import "ComposeMessageViewController.h"
#import "MainViewController.h"

@interface MessagesViewController ()  {
    NSManagedObjectContext * managedObjectContext;
    AppDelegate * appDelegate;
}

@end


@implementation MessagesViewController

@synthesize messageStack;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    managedObjectContext = appDelegate.persistentContainer.viewContext;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
               selector: @selector(refresh)
                   name: @"Message Received"
                 object: nil];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    friendButtonList = [MainViewController getFriendsFromContext: managedObjectContext];
    if (friendButtonList == nil) {
        [MainViewController showErrorPopup: self withMessage: @"Failed to load friend list"];
    }
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    appDelegate.currentViewController = self;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    MessageSelectionCell * cell = [tableView dequeueReusableCellWithIdentifier: @"MessageSelectionCellIdentifier"];
    if (cell == nil) {
        cell = [[MessageSelectionCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MessageSelectionCellIdentifier"];
    }
    
    Friend * friend = [friendButtonList objectAtIndex: indexPath.row];
    cell.recipient = friend;
    cell.friendName.text = friend.friendName;
    NSInteger messagesCount = [friend.messages count];
    if (messagesCount > 0) {
        Message * message = [friend.messages objectAtIndex: messagesCount - 1];
        cell.messagePreview.text = message.contents;
        cell.dateTime.text = [NSDate stringForDisplayFromDate: message.dateTime];
    } else {
        cell.messagePreview.text = @" ";
        cell.dateTime.text = @" ";
    }
    return cell;

}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 75.0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [friendButtonList count];
}

- (void) deleteMessage:(Message *) message {
    [managedObjectContext deleteObject: message];
    NSError * error;
    [managedObjectContext save: &error];
}

- (void) refresh {
    [messageStack reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    if ([segue.identifier isEqualToString: @"goToMessageCompose"]) {
        MessageSelectionCell *selectedCell = (MessageSelectionCell *) sender;
        ComposeMessageViewController *destinationVC = segue.destinationViewController;
        destinationVC.recipient = selectedCell.recipient;
        destinationVC.delegate = self;
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
