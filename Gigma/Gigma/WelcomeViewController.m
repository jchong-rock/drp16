//
//  MainViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "WelcomeViewController.h"
#import "FestivalSelectionCell.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface WelcomeViewController () {
    NSDictionary * displayNames;
}

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
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSString * festivalIsSet = [prefs stringForKey: @"FestivalIsSet"];
    if (festivalIsSet != nil) {
        [self performSegueWithIdentifier: @"goToMain" sender: self];
    }
    NSString * rsaName = [prefs stringForKey: @"RSAName"];
    if (rsaName == nil) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Choose display name" message: nil preferredStyle: UIAlertControllerStyleAlert];
            
        [alertController addTextFieldWithConfigurationHandler: ^(UITextField * textField) {
            textField.placeholder = @"Display name";
        }];
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: ^(UIAlertAction * action) {
            UITextField * textField = alertController.textFields.firstObject;
            NSString * enteredText = textField.text;
            
            // Use the entered text as needed
            AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [prefs setObject: enteredText forKey: @"RSAName"];
            appDelegate.multipeerDriver = [[MultipeerDriver alloc] init];
            [appDelegate.multipeerDriver startAdvertising];
        }];

        [alertController addAction: okAction];
        
        [self presentViewController: alertController animated: YES completion: nil];
        
    }
    // handle connection failure
    BOOL connectionSuccess = [data connect];
    if (!connectionSuccess) {
        [MainViewController showErrorPopup: self withMessage: @"Connection to database failed."];
        festivalButtonList = [[NSMutableArray alloc] init];
        displayNames = [[NSDictionary alloc] init];
    } else {
        festivalButtonList = [data getFestivalList];
        displayNames = [data getDisplayNames];
    }
    [data close];
    [buttonStack reloadData];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    
    FestivalSelectionCell * cell = [tableView dequeueReusableCellWithIdentifier: @"WelcomeCellIdentifier"];
    if (cell == nil) {
        cell = [[FestivalSelectionCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"WelcomeCellIdentifier"];
    }
    NSNumber * num = [festivalButtonList objectAtIndex: indexPath.row];
    cell.festivalID = [num integerValue];
    [cell.button setTitle: [displayNames objectForKey: num] forState: UIControlStateNormal];
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [festivalButtonList count];
}

- (IBAction) continueButtonPressed:(id) sender {
    FestivalSelectionCell * cell = (FestivalSelectionCell *) ((UIButton *) sender).superview.superview;
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: cell.button.titleLabel.text forKey: @"FestivalIsSet"];
    [prefs setInteger: cell.festivalID forKey: @"FestivalIDSet"];
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

- (IBAction) notListedButtonPressed:(id) sender {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: @"Unknown Festival" forKey: @"FestivalIsSet"];
    [prefs setInteger: 0 forKey: @"FestivalIDSet"];
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

@end
