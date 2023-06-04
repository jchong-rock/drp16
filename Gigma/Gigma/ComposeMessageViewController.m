//
//  ComposeMessageViewController.m
//  Gigma
//
//  Created by Jake Chong on 01/06/2023.
//

#import "ComposeMessageViewController.h"
#import "MessageCell.h"
#import "Message+CoreDataProperties.h"
#import "MessageDriver.h"
#import "AppDelegate.h"

@interface ComposeMessageViewController () {
    NSObject <MessageDriver> * messageDriver;
    CGRect textBarFrame;
}

@end

@implementation ComposeMessageViewController

@synthesize textBar;
@synthesize nameLabel;
@synthesize textField;
@synthesize messageStack;
@synthesize recipient;
@synthesize messageList;
@synthesize delegate;

- (void) viewDidLoad {
    [super viewDidLoad];
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    messageDriver = [[FakeMessageSender alloc] initWithContext: appDelegate.persistentContainer.viewContext];
    [NSNotificationCenter.defaultCenter addObserver: self selector: @selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object: nil];
    [NSNotificationCenter.defaultCenter addObserver: self selector: @selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object: nil];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissKeyboard)];

    [self.view addGestureRecognizer: tap];
}

-(void) dismissKeyboard {
    [textField resignFirstResponder];
}

- (void) keyboardWillShow:(NSNotification *) notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"%f",keyboardSize.height);
    textBarFrame = self.textBar.frame;
    [UIView animateWithDuration: 0.25 animations: ^{
        CGRect frame = self.textBar.frame;
        frame.origin.y -= keyboardSize.height - 42;
        self.textBar.frame = frame;
        UIEdgeInsets contentInset = self.messageStack.contentInset;
        contentInset.bottom += keyboardSize.height - 42;
        self.messageStack.contentInset = contentInset;
        [self.messageStack reloadData];
    }];
}

- (void) keyboardWillHide:(NSNotification *) notification {
    [UIView animateWithDuration: 0.25 animations: ^{
        self.textBar.frame = self->textBarFrame;
        self.messageStack.contentInset = UIEdgeInsetsZero;
        [self.messageStack reloadData];
    }];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    messageList = [NSMutableArray arrayWithArray: recipient.messages.array];
    nameLabel.text = recipient.friendName;
    [messageStack reloadData];
    [messageStack setContentOffset: CGPointMake(0, messageStack.contentSize.height) animated: NO];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    
    Message * message = [messageList objectAtIndex: indexPath.row];
    NSString * cellID = (message.weSentIt) ? @"SendTextCellIdentifier" : @"ReceiveTextCellIdentifier";
    
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
    }
    
    cell.content.text = message.contents;

    CGFloat horizontalIndent = 10.0;
    CGFloat verticalIndent = 0.0;
    
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

- (IBAction) goBack:(id) sender {
    [delegate refresh];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction) sendMessage:(id) sender {
    NSString * text = textField.text;
    if (![textField.text isEqual: @""]) {
        textField.text = @"";
        Message * message = [messageDriver sendMessage: text toFriend: recipient];
        [messageList addObject: message];
        [messageStack setContentOffset: CGPointMake(0, messageStack.contentSize.height) animated: YES];
        [messageStack reloadData];
    }
}


@end
