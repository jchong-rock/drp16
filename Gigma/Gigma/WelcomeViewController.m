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
#import "Paragraph+CoreDataProperties.h"

@interface WelcomeViewController () {
    NSDictionary * displayNames;
    AppDelegate * appDelegate;
}

@end

@implementation WelcomeViewController

@synthesize buttonStack;
@synthesize festivalButtonList;
@synthesize data;

- (void) viewDidLoad {
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    data = appDelegate.data;
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    appDelegate.currentViewController = self;
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSString * festivalIsSet = [prefs stringForKey: @"FestivalIsSet"];
    if (festivalIsSet != nil) {
        [self performSegueWithIdentifier: @"goToMain" sender: self];
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
    if ([data connect]) {
        NSDictionary <NSString *, NSString *> * foundDescription = [data getInfoWithFestivalID: cell.festivalID];
        [data close];
        [self saveFestivalPreferences: foundDescription];
    }
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

- (void) saveFestivalPreferences:(NSDictionary <NSString *, NSString *> *) description {
    
    NSManagedObjectContext * managedObjectContext = appDelegate.persistentContainer.viewContext;
    
    for (NSString * heading in description) {
        Paragraph * paragraph = [NSEntityDescription insertNewObjectForEntityForName: @"Paragraph" inManagedObjectContext: managedObjectContext];
        paragraph.heading = heading;
        paragraph.body = [description objectForKey: heading];
        NSError * error;
        [managedObjectContext save: &error];
    }
}

- (IBAction) notListedButtonPressed:(id) sender {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: @"Unknown Festival" forKey: @"FestivalIsSet"];
    [prefs setInteger: 0 forKey: @"FestivalIDSet"];
    //
    NSDictionary <NSString *, NSString *> * foundDescription = [data getInfoWithFestivalID: 0];
    [self saveFestivalPreferences: foundDescription];
    //
    [self performSegueWithIdentifier: @"goToMain" sender: self];
}

@end
