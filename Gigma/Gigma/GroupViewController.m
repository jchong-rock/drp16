//
//  FriendViewController.m
//  Gigma
//
//  Created by Jake Chong on 30/05/2023.
//

#import "GroupViewController.h"

@interface FriendViewController ()

@end

@implementation GroupViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    friendButtonList = [[NSMutableArray alloc] initWithObjects: @"You", nil];
}

- (BOOL) addFriend:(NSString *) name withID:(NSString *) uid {
    return [super addFriend: name withID: uid];
}

@end

