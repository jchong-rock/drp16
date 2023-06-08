//
//  AppDelegate.h
//  GigmaModel
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class BluetoothDriver;
@protocol DataBaseDriver;

NSString * deviceName(void);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer * persistentContainer;
- (void) saveContext;

@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) BluetoothDriver * bluetoothDriver;
@property (retain, strong, nonatomic) NSObject <DataBaseDriver> * data;

@end

