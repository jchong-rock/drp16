//
//  AppDelegate.h
//  GigmaModel
//
//  Created by Jake Chong on 31/05/2023.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class MultipeerDriver;
@protocol DataBaseDriver;
@class RSAManager;
@class MapCache;

NSString * deviceName(void);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer * persistentContainer;
- (void) saveContext;

@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) MultipeerDriver * multipeerDriver;
@property (retain, strong, nonatomic) NSObject <DataBaseDriver> * data;
@property (retain, strong, nonatomic) RSAManager * rsaManager;
@property (weak, nonatomic) UIViewController * currentViewController;
@property (retain, nonatomic) MapCache * mapCache;

@end

