//
//  CacheOverlay.m
//  Gigma
//
//  Created by Jake Chong on 24/06/2023.
//

#import "CacheOverlay.h"

@implementation CacheOverlay

- (NSURL *) URLForTilePath:(MKTileOverlayPath) path {
    NSURL * tilePath = [NSBundle.mainBundle URLForResource: @(path.y).stringValue withExtension: @"png" subdirectory: [NSString stringWithFormat: @"tiles/%ld/%ld", (long) path.z, (long) path.x]];
    if (tilePath != nil) {
        return tilePath;
    }
    return [NSBundle.mainBundle URLForResource: @"blank" withExtension: @"png" subdirectory: @"tiles"];
}

@end
