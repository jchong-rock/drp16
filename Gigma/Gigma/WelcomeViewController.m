//
//  MainViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "WelcomeViewController.h"
#import "FestivalSelectionCell.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize buttonStack;
@synthesize festivalButtonList;
@synthesize data;

- (void) viewDidLoad {
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    data = appDelegate.data;
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * festivalIsSet = [prefs stringForKey: @"FestivalIsSet"];
    if (festivalIsSet != nil) {
        [self performSegueWithIdentifier: @"goToMain" sender: self];
    }
    // handle connection failure
    BOOL connectionSuccess = [data connect];
    if (!connectionSuccess) {
        UIAlertController * popup = [UIAlertController alertControllerWithTitle: @"Error" message: @"Connection to database failed." preferredStyle: UIAlertControllerStyleAlert];

        UIAlertAction * ok = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {}];

        [popup addAction: ok];
        [self presentViewController: popup animated: YES completion: nil];
        festivalButtonList = [[NSMutableArray alloc] init];
        
    } else {
        festivalButtonList = [data getFestivalList];
    }
    [data close];
    [buttonStack reloadData];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    
    FestivalSelectionCell * cell = [tableView dequeueReusableCellWithIdentifier: @"WelcomeCellIdentifier"];
    if (cell == nil) {
        cell = [[FestivalSelectionCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"WelcomeCellIdentifier"];
    }

    [cell.button setTitle: [festivalButtonList objectAtIndex: indexPath.row] forState: UIControlStateNormal];
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [festivalButtonList count];
}

- (IBAction) continueButtonPressed:(id) sender {
    UIButton * cell = (UIButton *) sender;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: cell.titleLabel.text forKey: @"FestivalIsSet"];
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

- (IBAction) notListedButtonPressed:(id) sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: @"Unknown Festival" forKey: @"FestivalIsSet"];
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

@end
