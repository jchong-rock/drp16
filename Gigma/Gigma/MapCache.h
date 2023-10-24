//
//  MapCache.h
//  Gigma
//
//  Created by Jake Chong on 21/06/2023.
//

#import <MapKit/MapKit.h>
#import "AppDelegate.h"
@class Festival;
@protocol DataBaseDriver;

@interface MapCache : NSObject {
    BOOL isCached;
    AppDelegate * appDelegate;
    NSObject <DataBaseDriver> * databaseDriver;
}

@property (retain, nonatomic) MKTileOverlay * overlay;

- (void) clear;
- (BOOL) loadTilesForFestival:(NSInteger) festivalID;
// get tile for params

@end
