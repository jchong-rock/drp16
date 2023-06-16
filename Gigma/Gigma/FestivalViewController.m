//
//  FestivalViewController.m
//  Gigma
//
//  Created by Jake Chong on 31/05/2023.
//

#import "FestivalViewController.h"
#import "AppDelegate.h"
#import "Gigma-Swift.h"
#import "Paragraph+CoreDataProperties.h"
#import "ParagraphCell.h"

@interface FestivalViewController () {
    AppDelegate * appDelegate;
    NSUserDefaults * prefs;
    NSArray <Paragraph *> * paragraphs;
    NSManagedObjectContext * managedObjectContext;
}

@end

@implementation FestivalViewController

@synthesize titleLabel;
@synthesize settingsButton;
@synthesize paragraphTable;

- (void) viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    prefs = [NSUserDefaults standardUserDefaults];
    managedObjectContext = appDelegate.persistentContainer.viewContext;
    paragraphs = [MainViewController getParagraphsFromContext: managedObjectContext];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear: animated];
    [settingsButton setTitle: @"" forState: UIControlStateNormal];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear: animated];
    appDelegate.currentViewController = self;
    NSString * festivalIsSet = [prefs stringForKey: @"FestivalIsSet"];
    if (festivalIsSet != nil) {
        titleLabel.text = festivalIsSet;
    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *) indexPath {
    ParagraphCell * cell = [tableView dequeueReusableCellWithIdentifier: @"ParagraphCellIdentifier"];
    if (cell == nil) {
        cell = [[ParagraphCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"ParagraphCellIdentifier"];
    }
    
    Paragraph * paragraph = [paragraphs objectAtIndex: indexPath.row];
    [ParagraphCell adjustTextViewHeight: cell.body];
    cell.body.text = paragraph.body;
    cell.heading.text = paragraph.heading;

    return cell;

}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 226.0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [paragraphs count];
}

- (void) refresh {
    [paragraphTable reloadData];
}


@end
