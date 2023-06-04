//
//  AppDelegate.h
//  GigmaModel
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Gigma-Swift.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer * persistentContainer;
@property (retain, strong, nonatomic) NSObject <DataBaseDriver> * data;

- (void)saveContext;


@end

