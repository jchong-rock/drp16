//
//  ComposeMessageViewController.m
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import "ComposeMessageViewController.h"
#import "MessageCell.h"
#import "Message+CoreDataProperties.h"

@interface ComposeMessageViewController ()

@end

@implementation ComposeMessageViewController

@synthesize nameLabel;
@synthesize messageStack;
@synthesize recipient;
@synthesize messageList;

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    messageList = [NSMutableArray arrayWithArray: recipient.messages.array];
    NSLog(@"%lu", (unsigned long)[messageList count]);
    nameLabel.text = recipient.friendName;
    [messageStack reloadData];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    
    Message * message = [messageList objectAtIndex: indexPath.row];
    NSString * cellID = (message.weSentIt) ? @"SendTextCellIdentifier" : @"ReceiveTextCellIdentifier";
    
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
    }
    
    cell.content.text = message.contents;
    
    // set indentation
    CGFloat horizontalIndent = 10.0; // Set the desired horizontal indent
    CGFloat verticalIndent = 0.0; // Set the desired vertical indent
    
    UIEdgeInsets textInsets = UIEdgeInsetsMake(verticalIndent, horizontalIndent, verticalIndent, horizontalIndent);
    cell.content.textInsets = textInsets;

    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [messageList count];
}


@end
