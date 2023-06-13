//
//  AddCustomMarkerViewController.m
//  Gigma
//
//  Created by kup21 on 13/06/2023.
//

//#import <Foundation/Foundation.h>
#import "AddCustomMarkerViewController.h"
#import "AppDelegate.h"
#import "ColourConverter.h"
#import "Gigma-Swift.h"

@interface AddCustomMarkerViewController () {
    NSManagedObjectContext * managedObjectContext;
}
@end

@implementation AddCustomMarkerViewController
@synthesize markerNameField;
@synthesize markerName;

- (void) viewDidLoad {
    [super viewDidLoad];

    AppDelegate * appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    managedObjectContext = appDelegate.persistentContainer.viewContext;
}
- (BOOL) addCustomMarker {
    for (CustomMarker * marker in [MainViewController getCustomMarkersFromContext: managedObjectContext]) {
        if (markerName == marker.name) return NO;
    }
    if (markerName != nil) {
        CustomMarker * marker = [NSEntityDescription insertNewObjectForEntityForName:@"CustomMarker" inManagedObjectContext:managedObjectContext];
        marker.name = markerName;
        marker.latitude = coordinate.latitude;
        marker.longitude = coordinate.longitude;
        //TODO:
        NSError * error;
        [managedObjectContext save: &error];
        return YES;
        
    }
    
    return NO;
}

- (IBAction) saveButtonPressed: (id) sender {
    
    if ([markerName length] == 0) {
        markerNameField.textColor = UIColor.redColor;
        markerNameField.text = @"Markername cannot be empty";
    }
    
    
    BOOL saveSuccess = [self addCustomMarker];
    
    if (saveSuccess) {
        [self dismissViewControllerAnimated: YES completion: nil];
    } else {
        markerNameField.textColor = UIColor.redColor;
        markerNameField.text = @"Another marker with the same name exists!";
    }
}

- (void)setCoordinate:(CLLocationCoordinate2D)coord {
    coordinate = coord ;
}


@end
