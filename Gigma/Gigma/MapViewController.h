//
//  MapViewController.h
//  Gigma
//
//  Created by Jake Chong on 30/05/2023.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController {
    IBOutlet MKMapView * mapView;
}

@property (retain, nonatomic) MKMapView * mapView;

@end
