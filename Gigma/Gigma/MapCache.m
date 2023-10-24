//
//  MapCache.m
//  Gigma
//
//  Created by Jake Chong on 24/06/2023.
//

#import "MapCache.h"
#import "CacheOverlay.h"
#import "Gigma-Swift.h"

@implementation MapCache

@synthesize overlay;

- (instancetype) init {
    self = [super init];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    databaseDriver = appDelegate.data;
    isCached = NO;
    self.overlay = [[CacheOverlay alloc] init];
    return self;
}

- (void) clear {
    // delete files
    isCached = NO;
}

- (BOOL) loadTilesForFestival:(NSInteger) festivalID {
    if (!isCached) {
        if (![databaseDriver connect]) {
            return NO;
        }
        [databaseDriver getTilesWithFestivalID: festivalID];
        [databaseDriver close];
        isCached = YES;
    }
    return YES;
}

@end
