//
//  AddCustomMarkerViewController.h
//  Gigma
//
//  Created by kup21 on 13/06/2023.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomMarker+CoreDataProperties.h"

@protocol AddCustomMarkerDelegate <NSObject>

- (void) setCoordinate: (CLLocationCoordinate2D) coord;

@end

@interface AddCustomMarkerViewController : UIViewController <AddCustomMarkerDelegate> {
    CLLocationCoordinate2D coordinate;
    IBOutlet UITextField * markerNameField;
}

@property (retain, nonatomic) UITextField * markerNameField;
@property (retain, nonatomic) NSString * markerName;
//@property (retain, nonatomic) UILabel * nicknameTextLabel;

- (BOOL) addCustomMarker;
- (IBAction) saveButtonPressed:(id) sender;

@end
