//
//  FriendViewController.m
//  Gigma
//
//  Created by Jake Chong on 30/05/2023.
//

#import "FriendViewController.h"
#import "AddFriendViewController.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

@synthesize buttonStack;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // change this to init instead of initWithObjects
    friendButtonList = [[NSMutableArray alloc] initWithObjects:@"friend1", nil];
    friends = [[NSMutableDictionary alloc] init];
}

- (void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender {
    
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
    if ([friends objectForKey: name] == nil) {
        [friends setObject: uid forKey: name];
        [friendButtonList addObject: name];
        return YES;
    }
    return NO;
}


@end

