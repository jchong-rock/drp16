//
//  UIApplication+CurrentViewController.h
//  Gigma
//
//  Created by Jake Chong on 15/06/2023.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CustomColourViewController : UIColorPickerViewController

@property (retain, nonatomic) NSString * markerName;
@property (retain, nonatomic) NSNumber * locationLatitude;
@property (retain, nonatomic) NSNumber * locationLongitude;

@end
