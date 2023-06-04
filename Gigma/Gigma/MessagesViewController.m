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
}

@end


@implementation MessagesViewController

@synthesize messageStack;

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
        [MainViewController showErrorPopup: self withMessage: @"Failed to load friend list"];
    }
    friendButtonList = mutableFetchResults;
}

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return YES;
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Friend * friend = [friendButtonList objectAtIndex: indexPath.row];
        for (Message * message in friend.messages) {
            [managedObjectContext deleteObject: message];
        }
        [friendButtonList removeObjectAtIndex: indexPath.row];
        [messageStack reloadData];
        NSError * error;
        [managedObjectContext save: &error];
    }
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

// change to use real method
- (void) sendMessage:(NSString *) content toFriend:(Friend *) friend {
    if (content != nil) {
        Message * message = [NSEntityDescription insertNewObjectForEntityForName: @"Message" inManagedObjectContext: managedObjectContext];
        message.recipient = friend;
        message.dateTime = [NSDate date];
        message.weSentIt = YES;
        message.wasRead = NO;
        message.contents = content;
        [messageStack reloadData];
        NSError * error;
        [managedObjectContext save: &error];
    }
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

@end
