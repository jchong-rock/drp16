//
//  MapSettings.m
//  Gigma
//
//  Created by Jake Chong on 03/06/2023.
//

#import "MapSettingsViewController.h"
#import "AppDelegate.h"
#import "MapSetting+CoreDataProperties.h"
#import "MainViewController.h"
#import "MapSettingsCell.h"

@interface MapSettingsViewController () {
    NSManagedObjectContext * managedObjectContext;
}
@end

@implementation MapSettingsViewController

@synthesize settingStack;
@synthesize prefButtonList;

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    managedObjectContext = appDelegate.persistentContainer.viewContext;
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    NSEntityDescription * entity = [NSEntityDescription entityForName: @"MapSetting" inManagedObjectContext: managedObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity: entity];
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"prefName" ascending: YES];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [request setSortDescriptors: sortDescriptors];
    
    NSError * error;
    NSMutableArray * mutableFetchResults = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    if (mutableFetchResults == nil) {
        [MainViewController showErrorPopup: self withMessage: @"Failed to load preferences list"];
    }
    prefButtonList = mutableFetchResults;
}

- (MapSettingsCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    MapSettingsCell * cell = [tableView dequeueReusableCellWithIdentifier: @"MapSettingCellIdentifier"];
    if (cell == nil) {
        cell = [[MapSettingsCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"MapSettingCellIdentifier"];
    }
    
    MapSetting * pref = [prefButtonList objectAtIndex: indexPath.row];
    cell.pref = pref;
    cell.textLabel.text = pref.prefName;
    cell.toggle.on = pref.enabled;
    return cell;
}

- (IBAction) changePrefValue:(id) sender {
    MapSettingsCell * pref = (MapSettingsCell *) ((UISwitch *) sender).superview.superview;
    pref.pref.enabled = !pref.pref.enabled;
    [settingStack reloadData];
    NSError * error;
    [managedObjectContext save: &error];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [prefButtonList count];
}

@end
